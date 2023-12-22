#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "mp5.h"
#include "mp10.h"


//
// These variables hold the heads of two singly-linked lists of 
// requests.  
//
// The avaialble list consists of unpaired requests: partner 
// should be NULL, and next is used to form the list.   
// 
// The shared list consists of groups with non-empty start and end 
// vertex intersections.  Only one of the requests in the group is in 
// the list.  The others are linked through the first's partner field 
// and then through the next field of the others in the group.  The 
// next field of the first request in a group is used to form the
// shared list.
//
// Note: for MP2, you should only build groups of two in the shared
// list.
//


//Introductionary paragraph:
//In this week's mp10, I extend last week’s program to make use of dynamic allocation in several ways 
//and to attempt to pair up requests from a list of many requests. More specifically, I manage 
//dynamic allocation of vertex sets and paths, subroutines that enable, calculate, and 
//use “mini maps” based on a high level of a pyramid tree, and a subroutine that attempts to find a 
//partner for a request among a linked list of unpaired requests. 
//In this program, successful pairings must then be moved into a list of paired requests.

static request_t* available = NULL;
static request_t* shared = NULL;

/*
 * handle_request
 *
 * handle a new request by attempting to find walking partners among previous requests;
 * INPUT: g--the whole graph
 *        h--the heap
 *        p--the pyr_tree
 *        r--the single request
 * OUTPUTS: two updated linked list 
 * RETURN VALUE: 1 for success and 0 for fail
 */

int32_t
handle_request (graph_t* g, pyr_tree_t* p, heap_t* h, request_t* r)
{
    mark_vertex_minimap(g, p); //mark the g and p with minimap
    r->src_vs = new_vertex_set(); //allocate vertex sets for request
    if(!r->src_vs)  return 0;
    r->dst_vs = new_vertex_set(); //allocate vertex sets for request
    if(!r->dst_vs)
    {
        free_vertex_set(r->src_vs);
        return 0;
    }
    vertex_set_t* match_src = new_vertex_set(); //allocate vertex sets for mapping
    if(!match_src)
    {
        free_vertex_set(r->src_vs);
        free_vertex_set(r->dst_vs);
        return 0;
    }
    vertex_set_t* match_dst = new_vertex_set(); //allocate vertex sets for mapping
    if(!match_dst)
    {
        free_vertex_set(r->src_vs);
        free_vertex_set(r->dst_vs);
        free_vertex_set(match_src);
        return 0;
    }
    r->path = new_path();
    if(!r->path)
    {
        free_vertex_set(r->src_vs);
        free_vertex_set(r->dst_vs);
        free_vertex_set(match_src);
        free_vertex_set(match_dst);
        return 0;
    }
    find_nodes(&(r->from), r->src_vs, p, 0);    //fill the corresponding vertex set
    find_nodes(&(r->to), r->dst_vs, p, 0); 
    if (r->src_vs->count == 0 || r->dst_vs->count == 0) //if no vertex return 0 and free the block
    {
        free_vertex_set(r->src_vs);
        free_vertex_set(r->dst_vs);
        free_vertex_set(match_src);
        free_vertex_set(match_dst);
        free_path(r->path);
        return 0;
    }
    build_vertex_set_minimap(g, r->src_vs); //build minimap of r->src_vs and r->dst_vs
    build_vertex_set_minimap(g, r->dst_vs);
    //allocate memory for matching set
    match_src->id_array_size = r->src_vs->count;
    match_src->id = realloc(match_src->id,match_src->id_array_size * sizeof(int32_t));
    match_dst->id_array_size = r->dst_vs->count;
    match_dst->id = realloc(match_dst->id,match_dst->id_array_size * sizeof(int32_t));
    if(match_dst->id == NULL || match_src->id == NULL)
    {
        //if matching set allocation fails, free the block and return 0;
        free_vertex_set(r->src_vs);
        free_vertex_set(r->dst_vs);
        free_vertex_set(match_src);
        free_vertex_set(match_dst);
        free_path(r->path);
        return 0;
    }
    request_t* prev;    //pointer to the previous element in linked list
    for(request_t* t = available; t != NULL; prev = t, t = t->next)
    {
        if((!(r->src_vs->minimap & t->src_vs->minimap)) || (!(r->dst_vs->minimap & t->dst_vs->minimap))) continue;
        //if minimap with no overlap, skip this request
        if(merge_vertex_sets(r->src_vs, t->src_vs, match_src) && merge_vertex_sets(r->dst_vs, t->dst_vs, match_dst))
        //determine whether two requests have intersection points and let match_src and match_dst filled with intersection end and start points
        {
            if(dijkstra(g, h, match_src, match_dst, r->path)) 
            {
                if(t == available)  available = t->next; //special case: node at head
                else prev->next = t->next;
                r->next = shared;
                shared = r;
                r->partner = t;
                t->partner = t->next = NULL; //remove the node and update the linked list
                free_vertex_set(t->src_vs); //free src_vs
                free_vertex_set(r->src_vs);
                t->src_vs = r->src_vs = match_src;
                build_vertex_set_minimap(g, r->src_vs); //build minimap for matched set
                free_vertex_set(t->dst_vs); //free dst_vs
                free_vertex_set(r->dst_vs);
                t->dst_vs = r->dst_vs = match_dst;
                build_vertex_set_minimap(g, r->dst_vs); //build minimap for matched set
                build_path_minimap(g, r->path);
                t->path = r->path; //update the path
                return 1;
            }
        }
    }
    free_vertex_set(match_src);
    free_vertex_set(match_dst);
    free_path(r->path); //free matching set and path
    r->next = available;
    r->path = NULL;
    r->partner = NULL;
    available = r; //insert the node at the head of linked list
    return 1;


}


void
print_results ()
{
    request_t* r;
    request_t* prt;

    printf ("Matched requests:\n");
    for (r = shared; NULL != r; r = r->next) {
        printf ("%5d", r->uid);
	for (prt = r->partner; NULL != prt; prt = prt->next) {
	    printf (" %5d", prt->uid);
	}
	printf (" src=%016lX dst=%016lX path=%016lX\n", r->src_vs->minimap,
		r->dst_vs->minimap, r->path->minimap);
    }

    printf ("\nUnmatched requests:\n");
    for (r = available; NULL != r; r = r->next) {
        printf ("%5d src=%016lX dst=%016lX\n", r->uid, r->src_vs->minimap,
		r->dst_vs->minimap);
    }
}


int32_t
show_results_for (graph_t* g, int32_t which)
{
    request_t* r;
    request_t* prt;

    // Can only illustrate one partner.
    for (r = shared; NULL != r; r = r->next) {
	if (which == r->uid) {
	    return show_find_results (g, r, r->partner);
	}
	for (prt = r->partner; NULL != prt; prt = prt->next) {
	    if (which == prt->uid) {
		return show_find_results (g, prt, r);
	    }
	}
    }

    for (r = available; NULL != r; r = r->next) {
        if (which == r->uid) {
	    return show_find_results (g, r, r);
	}
    }
    return 0;
}


static void
free_request (request_t* r)
{
    free_vertex_set (r->src_vs);
    free_vertex_set (r->dst_vs);
    if (NULL != r->path) {
	free_path (r->path);
    }
    free (r);
}

void
free_all_data ()
{
    request_t* r;
    request_t* prt;
    request_t* next;

    // All requests in a group share source and destination vertex sets
    // as well as a path, so we need free those elements only once.
    for (r = shared; NULL != r; r = next) {
	for (prt = r->partner; NULL != prt; prt = next) {
	    next = prt->next;
	    free (prt);
	}
	next = r->next;
	free_request (r);
    }

    for (r = available; NULL != r; r = next) {
	next = r->next;
	free_request (r);
    }
}


