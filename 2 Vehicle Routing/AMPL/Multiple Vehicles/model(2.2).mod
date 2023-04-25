##################################################
#Model File For Multiple Vehicles (2 Vehicle Routing)
#
#Defines model for finding shortest delivery route with 3 available vehicles
##################################################


#############Parameters###########################

#Loads in composite customers, depot, and vehicles sets
set c_Customers ordered;
set Depots ordered;
set Vehicles;

#Defines node set to be the union of the composite customers and depot
set Nodes := c_Customers union Depots ordered;

#Defines set of possible arcs between each node
set Arcs := {i in Nodes, j in Nodes: i<>j};

#Loads in the x coordinates and y coordinates of the depot and composite customers
param xpos{Nodes};
param ypos{Nodes};

#Defines the distance cost of travelling between nodes to be l2 norm
param distance_cost {(i,j) in Arcs} := 
	sqrt((xpos[j] - xpos[i])**2 + (ypos[j] - ypos[i])**2);

#Defines N as the number of different nodes, used for sub-tour elimination
param N := card(Nodes);


#############Variables############################

#Defines binary variable indicating if a given arc is on the route visited by a vehicle k
var on_route {i in Nodes, j in Nodes, k in Vehicles} binary;

#Defines ordering decision variable, again used for sub-tour elimination
var y{Nodes, Vehicles} >=0;


#############Objective############################

#Minimises total cost across all vehicles for taking their route
minimize Total_Cost:
	sum{(i,j) in Arcs, k in Vehicles} on_route[i,j,k] * distance_cost[i,j];


#############Constraints##########################	

subject to

##Ensures one route out of each node
One_Out {i in Nodes}:
    sum{(i,j) in Arcs, k in Vehicles} on_route[i,j,k] = 1;

#Ensures one route in to each node
One_In {i in Nodes}:    
	sum{(j,i) in Arcs, k in Vehicles} on_route[j,i,k] = 1;
    
#Ensures that each vehicle is on a continuous route
Route_Continuity {i in Nodes, k in Vehicles}:
	sum{j in Nodes} on_route[i,j,k] - sum{j in Nodes} on_route[j,i,k] = 0;

#Ensures each vehicle starts at the depot
Start_Depot {k in Vehicles}:
	sum{i in Nodes} on_route["d1",i,k] = 1;
	
#Ensures no sub-tours on each route, using the ordering variable
Sub_Tour {(i,j) in Arcs, k in Vehicles: i != "d1" and j!= "d1"}:
	y[i,k] - y[j,k] + N*on_route[i,j,k] <= N - 1;
	
		
    
    
    
 

