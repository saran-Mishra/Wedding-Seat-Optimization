# SETS #
set TABLES; # table number, from 1 to n, where n is the maximum number of tables
set GUESTS; # guest number, from 1 to m, where m is the maximum number of guests

# PARAMETERS #
param A; # maximum number of people at a table
param B; # minimum people at each table the guest knows
param C{GUESTS,GUESTS}; # connection matrix between all the people at the wedding
param n; # maximum number of tables
param m; # maximum number of guests

# VARIABLES #
var Gj{TABLES,GUESTS} binary; # set to 1 if guest j is at table i, otherwise 0
var Gk{TABLES,GUESTS} binary; # set to 1 if guest k is at table i, otherwise 0 (not sure why we need two though)
var Pjk{TABLES,GUESTS,GUESTS} binary; # = Gji*Gki = 1 if guests j and k are both at table i, otherwise 0

# OBJECTIVE FUNCTION #
maximize TOTAL:sum{i in TABLES,j in 1/Users/Saran/Downloads/weddingseating.mod..m-1,k in j..m} C[j,k]*Pjk[i,j,k]; #maximize connections for guests j,k at table i

# CONSTRAINTS #
subject to Assign{j in GUESTS}:sum{i in TABLES}Gj[i,j]=1; # Everyone assigned to a table
subject to NotTooMany{i in TABLES}:sum{j in GUESTS}Gj[i,j]<=A; # Every table has less than or equal to the max guests at table
subject to SetPjk{i in TABLES, j in GUESTS, k in GUESTS}:Pjk[i,j,k]=Gj[i,j]*Gk[i,k]; # Hopefully this will work
subject to NotAlone{i in TABLES,k in GUESTS}:sum{j in GUESTS}Pjk[i,j,k]>=(B+1)*Gk[i,k]; # Every guest knows someone at table
subject to LessMaxj{i in TABLES,k in GUESTS}:sum{j in GUESTS}Pjk[i,j,k]<=A*Gk[i,k];
subject to LessMaxk{i in TABLES,j in GUESTS}:sum{k in GUESTS}Pjk[i,j,k]<=A*Gj[i,j];
subject to EqualG{i in TABLES,j in GUESTS}:Gj[i,j]=Gk[i,j];
