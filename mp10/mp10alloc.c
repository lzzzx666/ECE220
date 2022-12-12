#include <stdint.h>
#include <stdlib.h>

#include "mp10.h"

//Introductionary paragraph:
//In this week's mp10, I extend last week’s program to make use of dynamic allocation in several ways 
//and to attempt to pair up requests from a list of many requests. More specifically, I manage 
//dynamic allocation of vertex sets and paths, subroutines that enable, calculate, and 
//use “mini maps” based on a high level of a pyramid tree, and a subroutine that attempts to find a 
//partner for a request among a linked list of unpaired requests. 
//In this program, successful pairings must then be moved into a list of paired requests.


/*
 * new_vertex_set
 *
 * try to allocate a new vertex set.
 * INPUT: none
 * OUTPUTS: none
 * RETURN VALUE: new pointer p for success and NULL for fail
 */

vertex_set_t*
new_vertex_set ()
{
    vertex_set_t* p = malloc(sizeof(vertex_set_t));//try to malloc vertex set
    if(!p)  return NULL;
    int32_t* idp = malloc(16 * sizeof(int32_t));//try to malloc vertex set's id (use temp pointer)
    if(!idp) 
    {
        free(p);
        return NULL;
    }
    //initialize fields
    p->count = 0;
    p->id_array_size = 16;
    p->id = idp;
    p->minimap = 0;
    return p;
}

/*
 * free_vertex_set
 *
 * free a vertex set and its id array.
 * INPUT: none
 * OUTPUTS: none
 * RETURN VALUE: none
 */

void
free_vertex_set (vertex_set_t* vs)
{
    if(vs) //if vertex set is not null, free the vertex set and its id
    {
        if(vs->id)  free(vs->id);
        free(vs);
    }
}

/*
 * new_path
 *
 * try to allocate a new path
 * INPUT: none
 * OUTPUTS: none
 * RETURN VALUE: new pointer p for success and NULL for fail
 */

path_t*
new_path ()
{
    path_t* p = malloc(sizeof(path_t));//try to malloc new path
    if(!p)  return NULL;
    int32_t* idp = malloc(16 * sizeof(int32_t));//try to malloc new path's id 
    if(!idp){
        free(p);
        return NULL;
    }
    //initialize fields
    p->id = idp;
    p->n_vertices = p->minimap = p->tot_dist = 0;
    return p;
}

/*
 * free_path
 *
 * free a path and its id array.
 * INPUT: none
 * OUTPUTS: none
 * RETURN VALUE: none
 */

void
free_path (path_t* path)
{
    if(path) //if path is not null, free the path and its id
    {
        if(path->id)  free(path->id);
        free(path);
    }
}

