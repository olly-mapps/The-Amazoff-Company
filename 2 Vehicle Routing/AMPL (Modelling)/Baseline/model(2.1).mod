##################################################
#Model File For Capacitated Model (2 Vehicle Routing)
#
#Defines model for finding shortest delivery route with 1 vehicle
##################################################


#############Parameters###########################

#Loads in composite customers and depot set
set c_Customers ordered;
set Depots ordered;

#Defines node set to be the union of the composite customers and depot
set Nodes := c_Customers union Depots ordered;

#Defines set of possible arcs between each node
set Arcs := {i in Nodes, j in Nodes: i<>j};

#Loads in the x coordinates and y coordinates of the depot and customers
param xpos{Nodes};
param ypos{Nodes};

#Defines the distance cost of travelling between nodes to be l2 norm
param distance_cost {(i,j) in Arcs} := 
	sqrt((xpos[j] - xpos[i])**2 + (ypos[j] - ypos[i])**2);

#Defines N as the number of different nodes, used for sub-tour elimination
param N := card(Nodes);


#############Variables############################

#Defines ordering decision variable, again used for sub-tour elimination
var u{Nodes} >= 0, <= N-1;

#Defines binary variable indicating if a given arc is on the route	
var on_route {i in Nodes, j in Nodes} binary;


#############Objective############################

#Minimises total cost of taking the route
minimize Total_Cost:
	sum{(i,j) in Arcs} on_route[i,j] * distance_cost[i,j];
	

#############Constraints##########################

subject to

#Ensures one route out of each node
One_Out {i in Nodes}:
    sum{(i,j) in Arcs} on_route[i,j] = 1;

#Ensures one route in to each node
One_In {i in Nodes}:    
	sum{(j,i) in Arcs} on_route[j,i] = 1;
    
##Define subtour elimination constraints##

#1. Ensures that each node on the route comes after each 
#	other in the ordering variable
MTZ_1 {(i,j) in Arcs: i<>j and i != "d1" and j!= "d1"}:
	u[i] - u[j] + N*on_route[i,j] <= N - 1;

#2. Ensures that d1 is the start of the ordering
MTZ_2 {i in Nodes: i != "d1"}:
	u[i] <= N - 1 - (N - 2)*on_route["d1",i];

#3. Ensures d1 is also at the end of ordering
MTZ_3 {i in Nodes: i != "d1"}:
	u[i] >= 1 + (N - 2)*on_route[i,"d1"];

    
    
    
 

