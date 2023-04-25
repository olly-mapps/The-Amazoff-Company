##################################################
#Model File For Baseline Model (1 Warehousing)
#
#Models the assignment of customers to facilities
##################################################


#############Parameters###########################

#Defines the set of customers and facilities
set Customers ordered;
set Facilities ordered;

#Loads in the coordinates of the customers
param c_x{Customers};
param c_y{Customers};

#Loads in the coordinates of the facilities
param f_x{Facilities};
param f_y{Facilities};

#Defines the set of connections that go between customers and facilities.
set Arcs := {i in Customers, j in Facilities: i <> j};

#Defines the cost function as the l_1 norm, which is given
param assign_cost {i in Customers, j in Facilities}
	:= (abs(f_x[j] - c_x[i]) + abs(f_y[j] - c_y[i]));

#Defines the opening cost of a given facility	
param open_cost {f in Facilities}
	:= 100 * (3**(-ord(f)));
	
	
#############Variables############################

#Binary variable indicating if a facility is opened
var facility {f in Facilities} binary;

#Binary variable indicating if a customer has been assigned to a facility.
var assign {(i,j) in Arcs} binary;


#############Objective################################

#Objective function minimising cost of assignments, and opening costs of facilities
minimize Total_Cost:
	sum{i in Customers, j in Facilities} assign[i,j] * assign_cost[i,j] 
	+ sum{f in Facilities} facility[f] * open_cost[f];


#############Constraints##############################

subject to

#Ensures only one assignment per customer
One_Assignment {i in Customers}:
		sum{j in Facilities} assign[i,j] = 1;

#Ensures that only open facilities can be assigned customers to.	
Open_Facility {i in Customers, j in Facilities}:
    assign[i,j] <= facility[j];
 
	
