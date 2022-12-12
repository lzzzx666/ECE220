#include <stdint.h>
#include <stdio.h>

#include "mp10.h"

//Introductionary paragraph:
//In this week's mp10, I extend last week’s program to make use of dynamic allocation in several ways 
//and to attempt to pair up requests from a list of many requests. More specifically, I manage 
//dynamic allocation of vertex sets and paths, subroutines that enable, calculate, and 
//use “mini maps” based on a high level of a pyramid tree, and a subroutine that attempts to find a 
//partner for a request among a linked list of unpaired requests. 
//In this program, successful pairings must then be moved into a list of paired requests.


/*
 * mark_vertex_minimap
 *
 * Marks each graph vertex in g with a minimap bit number based on the pyramid tree p.
 * INPUT: g--the whole graph
 *        p--the pyr_tree that contain relative relations
 * OUTPUTS: the graph with marked minimap
 * RETURN VALUE: 1 for success
 */
int32_t 
mark_vertex_minimap (graph_t* g, pyr_tree_t* p)
{
    if (g->n_vertices <= 64)
    //If the graph has 64 vertices or fewer, we just simply use each 
    //vertex's array index for the vertex's mm_bit field.
    {
        for (int32_t i = 0; i < g->n_vertices; i++)
        {
            g->vertex[i].mm_bit = i;
        }
        
    }
    else
    //Otherwise, for each graph vertex, our function must identify 
    //the pyramid tree node corresponding to each vertex
    {
        for (int32_t i = p->n_nodes - 1; i >= (p->n_nodes - 2) / 4; i--)
        {
            int32_t j = i;
            while(j > 84)
            {
                j = (j - 1) / 4; //Find the ancestor node
            }
            g->vertex[p->node[i].id].mm_bit = j - 21;
            //Set the vertex's mm_bit to (ancestor's node index - 21).
        }
    }
    return 1;
}

/*
 * build_vertex_set_minimap
 *
 * builds a minimap for a vertex set.
 * INPUT: g--the whole graph
 *        vs--the vertex set wanted to be builded with minimap
 * OUTPUTS: vs->minimap after integration
 * RETURN VALUE: none
 */
void 
build_vertex_set_minimap (graph_t* g, vertex_set_t* vs)
{
    vs->minimap = 0ULL;
    for (int32_t i = 0; i < vs->count; i++)
    {
        vs->minimap |= (1ULL << g->vertex[vs->id[i]].mm_bit);
        // OR mm_bits in "vs->id" together into minimap
    }
}

/*
 * build_path_minimap
 *
 * builds a minimap for a vertex set.
 * INPUT: g--the whole graph
 *        p--the path wanted to be builded with minimap
 * OUTPUTS: p->minimap after integration
 * RETURN VALUE: none
 */
void 
build_path_minimap (graph_t* g, path_t* p)
{
    p->minimap = 0ULL;
    for (int32_t i = 0; i < p->n_vertices; i++)
    {
        p->minimap |= (1ULL << g->vertex[p->id[i]].mm_bit);
        // OR mm_bits in "p->id" together into minimap
    }
}

/*
 * merge_vertex_sets
 *
 * merges (intersects) two vertex sets into a third vertex set. 
 * INPUT: v1--first set
 *        v2--second set
 *        vint--set to hold the resulting number of ids.
 * OUTPUTS: vint which hold the resulting number of ids.
 * RETURN VALUE: 1 for success and 0 for fail
 */
int32_t
merge_vertex_sets (const vertex_set_t* v1, const vertex_set_t* v2,
		   vertex_set_t* vint)
{
    vint->count = 0;
    int32_t p1 = 0, p2 = 0;
    while (p1 != v1->count && p2 != v2->count)
    {
        if (v1->id[p1] == v2->id[p2])
        {
            vint->id[vint->count++] = v1->id[p1]; //get the common element
            p1++,p2++;
        }
        //when element isn't common just increment the pointer
        else if (v1->id[p1] < v2->id[p2]) p1++;
        else if (v1->id[p1] > v2->id[p2]) p2++;
    }
    return (vint->count != 0); //if no common element return 0 otherwise 1
}