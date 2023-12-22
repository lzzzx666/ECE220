#include <stdint.h>
#include <stdio.h>

#include "mp5.h"
#include "mp9.h"

//Introductionary paragraph:
//In this mp, I try to implement a request matching and path finding subroutines that helps people to
//find walking partners. This program can identify possible starting and ending points groups and find the
//shortest path between any pair of starting and ending points. To do this, I implement a heap for 
//the Dijkstra’s single-source shortest-paths algorithm which can help find the shortest path.

int32_t
match_requests (graph_t* g, pyr_tree_t* p, heap_t* h,
		request_t* r1, request_t* r2,
		vertex_set_t* src_vs, vertex_set_t* dst_vs, path_t* path)
{
	src_vs->count = dst_vs->count = 0;	//init counter to 0
	find_nodes (&(r1->from), src_vs, p, 0);	
	trim_nodes (g, src_vs, &(r2->from));	//find collective nodes in source set
	find_nodes (&(r1->to), dst_vs, p, 0);
	trim_nodes (g, dst_vs, &(r2->to));	//find collective nodes in destination set
	return (src_vs->count && dst_vs->count && dijkstra(g, h, src_vs, dst_vs, path)); //check validity and path existance
}
