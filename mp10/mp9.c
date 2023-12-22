#include <stdint.h>
#include <stdio.h>

#include "mp5.h"
#include "mp10.h"
#include <stdlib.h>

#define MY_INFINITY   1000000000


//Introductionary paragraph:
//In this week's mp10, I extend last week’s program to make use of dynamic allocation in several ways 
//and to attempt to pair up requests from a list of many requests. More specifically, I manage 
//dynamic allocation of vertex sets and paths, subroutines that enable, calculate, and 
//use “mini maps” based on a high level of a pyramid tree, and a subroutine that attempts to find a 
//partner for a request among a linked list of unpaired requests. 
//In this program, successful pairings must then be moved into a list of paired requests.



/*
 * find_nodes
 *
 * Find the nodes in range and add them into vertex set using realloc with id ascending sequence.
 * INPUT: loc--paticular location
 *        vs--the set as container
 *        p--the pyr_tree containing relations 
 *        nnum--number of nodes in tree p
 * OUTPUTS: vertex_set_t with added vertex
 * RETURN VALUE: None
 */
void
find_nodes (locale_t* loc, vertex_set_t* vs, pyr_tree_t* p, int32_t nnum)
{
    // Do not modify the following line nor add anything above in the function.
    record_fn_call ();
    if (p->n_nodes <= 4*nnum+1) //determine whether the node is leaf node
    {
        if (in_range(loc,p->node[nnum].x,p->node[nnum].y_left))
        {   //determine whether is leaf node should be added into the vertex set
            if (vs->count >= vs->id_array_size)
            {
                int32_t *temptr = realloc(vs->id, vs->id_array_size * 2 * sizeof(*(vs->id))); //realloc the new block
                if (temptr)
                {
                    vs->id = temptr;
                    vs->id_array_size *= 2; //double the size
                }
            }
            if (vs->count == 0) vs->id[(vs->count)++] = p->node[nnum].id; //special case for count = 0
            else
            {
                vs->count++;
                int32_t i;
                for (i = vs->count - 2; i >= 0; i--)
                {   //traverse from the end
                    if(p->node[nnum].id < vs->id[i])
                    {
                        vs->id[i + 1] = vs->id[i]; 
                    }
                    else break; //determine at which index to add the new vertex
                }
                vs->id[i + 1] = p->node[nnum].id; //add the new vertex
            }
        }
        return;     //return to the caller function
    }
    //approximate the circle as a square
    if (loc->x - loc->range <= p->node[nnum].x && loc->y - loc->range <=p->node[nnum].y_left)    find_nodes(loc,vs,p,4 * nnum + 1);
    if (loc->x + loc->range >= p->node[nnum].x && loc->y - loc->range <=p->node[nnum].y_right)   find_nodes(loc,vs,p,4 * nnum + 2);
    if (loc->x - loc->range <= p->node[nnum].x && loc->y + loc->range >=p->node[nnum].y_left)    find_nodes(loc,vs,p,4 * nnum + 3);
    if (loc->x + loc->range >= p->node[nnum].x && loc->y + loc->range >=p->node[nnum].y_right)   find_nodes(loc,vs,p,4 * nnum + 4);
    //recusively search the four subtree
}

/*
 * trim_nodes
 *
 * move the nodes in vs that far from loc
 * INPUT: loc--paticular location
 *        g--the whole graph
 *        vs--the vertex set that needed to be trimed
 * OUTPUTS: vertex_set_t trimed
 * RETURN VALUE: None
 */

void
trim_nodes (graph_t* g, vertex_set_t* vs, locale_t* loc)
{
    int32_t pointer = 0; //pointer first points to the start of vertex set
    int32_t ttt = vs->count;   //since vs->count will change, we need a variable to store it
    for(int32_t i = 0; i < ttt; i++ )
    {
        if ((in_range(loc,g->vertex[vs->id[pointer]].x,g->vertex[vs->id[pointer]].y)) == 0)//judge whether this vertex is near loc
        {
            //if is not near loc, we move it and move the vertex behind it in the set ahead a unit length.
            for (int32_t j = pointer; j < vs->count - 1; j++)   vs->id[j] = vs->id[j + 1];
            vs->count--;     //decreas the amount of vertex in the set
        }
        else pointer++;     //if is near loc, just increment pointer by 1
    }
}

/*
 * swap
 *
 * swap a and b (pointer exchange instead of value exchange)
 * INPUT: a--pointer to the first element
 *        b--pointer to the second element
 * OUTPUTS: two exchanged elements
 * RETURN VALUE: None
 */

void 
swap(int * a, int* b)
{
    int t = *a; //swap a and b (pointer exchange instead of value exchange)
    *a = *b;  
    *b = t; 
}

/*
 * heap_down
 *
 * recursively down a node in the heap
 * INPUT: g--the whole graph
 *        h--the heap
 *        i--the index in heap
 * OUTPUTS: downed heap
 * RETURN VALUE: None
 */

void
heap_down(graph_t* g, heap_t* h, int32_t i)
{
    int smallest = i;  // initialize smallest as root
    int l = 2*i + 1;   // left = 2*i + 1
    int r = 2*i + 2;   // right = 2*i + 2
    // if left child's from_src is smaller than root's from_src
    if (l < h->n_elts && g->vertex[h->elt[l]].from_src < g->vertex[h->elt[smallest]].from_src)
    {
        smallest = l;
    }    
    // if right child's from_src is smaller than smallest so far
    if (r < h->n_elts && g->vertex[h->elt[r]].from_src < g->vertex[h->elt[smallest]].from_src)
    {
        smallest = r;
    }      
    // if smallest is not root
    if (smallest != i)
    {
        swap(h->elt + i, h->elt + smallest);    //swap two vertex in heap
        g->vertex[h->elt[i]].heap_id = i;   //swap two vertex's heap_id
        g->vertex[h->elt[smallest]].heap_id = smallest;
        heap_down(g, h, smallest);  //recursively heapify the affected sub-tree
    }
}
/*
 * heap_up
 *
 * recursively up a node in the heap
 * INPUT: g--the whole graph
 *        h--the heap
 *        i--the index in heap
 * OUTPUTS: upped heap
 * RETURN VALUE: None
 */
void
heap_up(graph_t* g, heap_t* h, int32_t i)
{
    int32_t father = (i - 1) / 2; //initialize the father node
    if(father >= 0 && g->vertex[h->elt[i]].from_src < g->vertex[h->elt[father]].from_src)
    {   //if child's from_src is smaller than father's from_src
        swap(h->elt + i, h->elt + father);  //swap father and child vertex in heap
        g->vertex[h->elt[i]].heap_id = i;   //swap two vertex's heap_id
        g->vertex[h->elt[father]].heap_id = father;
        heap_up(g, h, father);  //recursively heapify the affected sub-tree
    }
}

/*
 * dijkstra
 *
 * find the shortest path between any node in the src vertex set and any
 * node in the destination vertex set, and write that path into path.
 * INPUT: g--the whole graph
 *        h--the heap
 *        path--the path needed to be filled
 *        dest--possible destination vertex set
 *        src--possible origin vertex set
 * OUTPUTS: a path from src to dest with shortest length
 * RETURN VALUE: return 1 on success, or 0 on failure.
 */

int32_t
dijkstra (graph_t* g, heap_t* h, vertex_set_t* src, vertex_set_t* dest,
          path_t* path)
{
    h->n_elts = g->n_vertices;  //initialze the number of elements in heap = the number of vertices in the whole graph
    for (int32_t i = 0; i < g->n_vertices; i++)
    {
        g->vertex[i].from_src = MY_INFINITY;   //init all vertices's from_src to infinity
        g->vertex[i].heap_id = i;   //init heap id as their index in graph
        h->elt[i] = i;  //init heap 
    }
    for (int32_t i = 0; i < src->count; i++)    
    {
        g->vertex[src->id[i]].from_src = 0; //init the from_src of vertices in source set to be 0 
        g->vertex[src->id[i]].pred = -1;    //mark these vertex's pred to -1 for reuse
    }
    for (int32_t i = (h->n_elts / 2) - 1; i >= 0; i--) heap_down(g, h, i);  //set up the heap using heap_down from a layer above the leaf node
    while (h->n_elts)
    {
        g->vertex[h->elt[0]].heap_id = h->n_elts - 1;   //swap two vertex's heap_id
        g->vertex[h->elt[h->n_elts - 1]].heap_id = 0;
        int32_t temp = h->elt[0];   //swap to vertex's position in the heap
        h->elt[0] = h->elt[--h->n_elts];
        h->elt[h->n_elts] = temp;
        heap_down(g, h, 0);     //adjust the heap using heap_down
        for (int32_t j = 0 ; j < g->vertex[temp].n_neighbors; j++)  //iterate all h->elt[0]'s neighbors
        {
            int u = (g->vertex[temp]).neighbor[j];
            if (g->vertex[temp].from_src + (g->vertex[temp]).distance[j] < g->vertex[u].from_src)//determine whether the distance should be freshed
            {
                g->vertex[u].from_src = g->vertex[temp].from_src + (g->vertex[temp]).distance[j]; //update to a better dist
                g->vertex[u].pred = temp;   //record the pred
                heap_up(g, h, g->vertex[u].heap_id);    //since the from_src decrease, we need to up it in the heap
            }
        }
    }
    path->n_vertices = 0;   
    path->tot_dist = MY_INFINITY;
    int32_t bestdest;
    for (int32_t i = 0; i < dest->count; i++)   //iterate all dest vertexs
    {
        if (g->vertex[dest->id[i]].from_src < path->tot_dist)//determine whether the bestdest should be freshed
        {
            bestdest = dest->id[i]; //update the bestdest
            path->tot_dist = g->vertex[dest->id[i]].from_src;   //record the shortest distance
        }
    }
    if (path->tot_dist == MY_INFINITY) return 0;
    int32_t tempdest = bestdest;
    while (tempdest != -1)  //when pred is not in source set
    {
        path->n_vertices++;
        tempdest = g->vertex[tempdest].pred;    //record the pred
    }
    path->id = malloc(sizeof(int32_t) * path->n_vertices); //malloc the new block
    if (path->id == NULL) return 0;     //if malloc is failed, return 0
    for (int32_t i = path->n_vertices - 1; i >= 0; i--)
    {
        path->id[i] = bestdest;
        bestdest = g->vertex[bestdest].pred;    //record the pred
    }
    return 1;
}

