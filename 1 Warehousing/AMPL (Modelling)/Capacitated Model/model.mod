set Customers ordered;
set Facilities ordered;

param c_x{Customers};
param c_y{Customers};

param f_x{Facilities};
param f_y{Facilities};

set Arcs := {i in Customers, j in Facilities: i <> j};

param assign_cost {i in Customers, j in Facilities}
	:= (abs(f_x[j] - c_x[i]) + abs(f_y[j] - c_y[i]));
	
param open_cost {f in Facilities}
	:= 100 * (3**(-ord(f)));

param capacity {f in Facilities}
	:= 100 * (2**(ord(f)));
	
param demands {c in Customers};

var facility {f in Facilities} binary;

var assign {(i,j) in Arcs} binary;

minimize Total_Cost:
	sum{i in Customers, j in Facilities} assign[i,j] * assign_cost[i,j] 
	+ sum{f in Facilities} facility[f] * open_cost[f];

subject to

One_Assignment {i in Customers}:
	sum{j in Facilities} assign[i,j] = 1;
	
Open_Facility {i in Customers, j in Facilities}:
    assign[i,j] <= facility[j];
    
Customer_Demand {f in Facilities}:
	sum{c in Customers} demands[c] * assign[c,f] <= capacity[f]*facility[f];
 
 
	
