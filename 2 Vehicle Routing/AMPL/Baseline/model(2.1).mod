set c_Customers ordered;
set Depots ordered;

set Nodes := c_Customers union Depots ordered;

set Arcs := {i in Nodes, j in Nodes: i<>j};

param xpos{Nodes};
param ypos{Nodes};

param distance_cost {(i,j) in Arcs} := 
	sqrt((xpos[j] - xpos[i])**2 + (ypos[j] - ypos[i])**2);
	
param N := card(Nodes);

var u{Nodes} >= 0, <= N-1;
	
var on_route {i in Nodes, j in Nodes} binary;

minimize Total_Cost:
	sum{(i,j) in Arcs} on_route[i,j] * distance_cost[i,j];
	
subject to

One_Out {i in Nodes}:
    sum{(i,j) in Arcs} on_route[i,j] = 1;

One_In {i in Nodes}:    
	sum{(j,i) in Arcs} on_route[j,i] = 1;
    
MTZ_1 {(i,j) in Arcs: i<>j and i != "d1" and j!= "d1"}:
	u[i] - u[j] + N*on_route[i,j] <= N - 1;

MTZ_2 {i in Nodes: i != "d1"}:
	u[i] <= N - 1 - (N - 2)*on_route["d1",i];

MTZ_3 {i in Nodes: i != "d1"}:
	u[i] >= 1 + (N - 2)*on_route[i,"d1"];

    
    
    
 

