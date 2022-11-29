#include <stdint.h>
#include <stdio.h>

#include "mp5.h"
#include "mp9.h"

#define MY_INFINITY   1000000000


//Introductionary paragraph:
//In this mp, I try to implement a request matching and path finding subroutines that helps people to
//find walking partners. This program can identify possible starting and ending points groups and find the
//shortest path between any pair of starting and ending points. To do this, I implement a heap for 
//the Dijkstra’s single-source shortest-paths algorithm which can help find the shortest path.


void
find_nodes (locale_t* loc, vertex_set_t* vs, pyr_tree_t* p, int32_t nnum)
{
    // Do not modify the following line nor add anything above in the function.
    record_fn_call ();
    if (p->n_nodes <= 4*nnum+1) //determine whether the node is leaf node
    {
        if (in_range(loc,p->node[nnum].x,p->node[nnum].y_left) && vs->count <= MAX_IN_VERTEX_SET)
        {   //determine whether is leaf node should be added into the vertex set
            vs->id[(vs->count)++] = p->node[nnum].id; //add this leaf node's vertex index into the vertex set
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

void 
swap(int * a, int* b)
{
    int t = *a; //swap a and b (pointer exchange instead of value exchange)
    *a = *b;  
    *b = t; 
}

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
    while (bestdest != -1)  //when pred is not in source set
    {
        if(path->n_vertices >= MAX_PATH_LENGTH) return 0;   //overflow case
        path->id[path->n_vertices++] = bestdest;
        bestdest = g->vertex[bestdest].pred;    //record the pred
    }
    int32_t p1 = 0, p2 = path->n_vertices - 1, tempo;
    while (p1 < p2)
    {
        //reverse the path array
        tempo = path->id[p1];
        path->id[p1] = path->id[p2];
        path->id[p2] = tempo;
        p1++,p2--;
    } 
    return 1;
}

