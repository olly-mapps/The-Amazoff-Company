set c_Customers ordered;
set Depots ordered;
set Vehicles;

set Nodes := c_Customers union Depots ordered;

set Arcs := {i in Nodes, j in Nodes: i<>j};

param xpos{Nodes};
param ypos{Nodes};

param distance_cost {(i,j) in Arcs} := 
	sqrt((xpos[j] - xpos[i])**2 + (ypos[j] - ypos[i])**2);
	
param N := card(Nodes);
	
var on_route {i in Nodes, j in Nodes, k in Vehicles} binary;

var y{Nodes, Vehicles} >=0;

minimize Total_Cost:
	sum{(i,j) in Arcs, k in Vehicles} on_route[i,j,k] * distance_cost[i,j];
	
subject to

One_Out {i in Nodes}:
    sum{(i,j) in Arcs, k in Vehicles} on_route[i,j,k] = 1;

One_In {i in Nodes}:    
	sum{(j,i) in Arcs, k in Vehicles} on_route[j,i,k] = 1;
    
Route_Continuity {i in Nodes, k in Vehicles}:
	sum{j in Nodes} on_route[i,j,k] - sum{j in Nodes} on_route[j,i,k] = 0;

Start_Depot {k in Vehicles}:
	sum{i in Nodes} on_route["d1",i,k] = 1;
	
Sub_Tour {(i,j) in Arcs, k in Vehicles: i != "d1" and j!= "d1"}:
	y[i,k] - y[j,k] + N*on_route[i,j,k] <= N - 1;
	
		
    
    
    
 

