# H3 bindings for PostgreSQL

- [Installation](#installation)
- [Development](#development)
- [Usage](#usage)

An extension for PostgreSQL that provides bindings for the [H3](https://uber.github.io/h3) indexing system.

## Installation

First, you must build [H3](https://uber.github.io/h3).

```
git clone https://github.com/uber/h3.git
cd h3
cmake -DCMAKE_C_FLAGS=-fPIC .
make
sudo make install
```

Then build h3-pg:

```
git clone ...
cd h3-pg
make
sudo make install
```

Run `psql` and load/use extension in database:

```
CREATE_EXTENSION h3;

SELECT h3_h3_to_children('880326b88dfffff', 9);
    h3_h3_to_children
-----------------
 890326b88c3ffff
 890326b88c7ffff
 890326b88cbffff
 890326b88cfffff
 890326b88d3ffff
 890326b88d7ffff
 890326b88dbffff
```

## Development

We provide a Dockerfile for development without installation of H3 and Postgres. The following requires that your system has `docker` installed.

First, build the docker image:

```
docker build -t h3-pg .
```

Then, build the extension and run the test suite:

```
docker run --rm h3-pg
```

Afterwards, to quickly build and test changes, run:

```
chmod -R 777 .
docker run --rm -it -v "$PWD":/tmp/h3-pg h3-pg
```

It will mount the code as a volume, and also mount the test output directory,
so output can be inspected. The chmod might be needed if you get permission
denied errors.

## Usage

Generally all functions have been renamed from camelCase to snake_case with an added `h3*`prefix. This means a few functions will have a double`h3*h3*` prefix, but we chose this for consistency. For example `h3ToChildren` becomes `h3_h3_to_children`.

### Indexing functions

#### h3_geo_to_h3(point, resolution) returns h3index

Converts native PostgreSQL point to hex at given resolution.

```
SELECT h3_geo_to_h3(POINT('64.7498111652365,89.5695822308866'), 8);
  h3_geo_to_h3
-----------------
 880326b88dfffff
(1 row)
```

#### h3_h3_to_geo(h3index) returns point

Finds the centroid of this hex in native PostgreSQL point type.

```
SELECT h3_h3_to_geo('880326b88dfffff');
            h3_h3_to_geo
-------------------------------------
 (64.7498111652365,89.5695822308866)
(1 row)
```

#### h3_h3_to_geo_boundary(h3index) returns polygon

Find the boundary of this hex, in native PostgreSQL polygon type.

```
SELECT h3_h3_to_geo_boundary(:hexagon);
                              h3_h3_to_geo_boundary
-----------------------------------------------------------------------------
 ((89.5656359347422,64.3352882950961),...,(89.570369702947,64.104106930976))
(1 row)
```

### Index inspection functions

#### h3_h3_get_resolution(h3index) returns integer

Returns the resolution of this hex.

```
SELECT h3_h3_get_resolution(:hexagon), h3_h3_get_resolution(:pentagon);
 h3_h3_get_resolution | h3_h3_get_resolution
-------------------+-------------------
                 8 |                 3
(1 row)
```

#### h3_h3_get_base_cell(h3index) returns integer

Returns the base cell number of the given hex.

```
SELECT h3_h3_get_base_cell(:hexagon), h3_h3_get_base_cell(h3_h3_to_parent(:hexagon));
 h3_h3_get_base_cell | h3_h3_get_base_cell
------------------+------------------
                2 |                2
(1 row)
```

#### h3_string_to_h3(cstring) returns h3index

Converts the string representation to H3Index representation. Not very useful, since the internal representation can already be displayed as text for output, and read as text from input.

```
SELECT h3_string_to_h3('880326b88dfffff);
 h3_string_to_h3
-----------------
 880326b88dfffff
(1 row)
```

#### h3_h3_to_string(h3index) returns cstring

Converts the H3Index representation of the index to the string representation. Not very useful, since the internal representation can already be displayed as text for output, and read as text from input.

```
SELECT h3_h3_to_string('880326b88dfffff);
 h3_h3_to_string
-----------------
 880326b88dfffff
(1 row)
```

#### h3_h3_is_valid(h3index) returns boolean

Returns whether this is a valid hex.

```
SELECT h3_h3_is_valid(:hexagon), h3_h3_is_valid(:pentagon), h3_h3_is_valid(:invalid);
 h3_h3_is_valid | h3_h3_is_valid | h3_h3_is_valid
-------------+-------------+-------------
 t           | t           | f
(1 row)

```

#### h3_h3_is_res_class_iii(h3index) returns boolean

Returns true if the resolution of the given index has a class-III rotation,
returns false if it has a class-II.

```
SELECT h3_h3_is_res_class_iii(:hexagon), h3_h3_is_res_class_iii(h3_h3_to_parent(:hexagon));
 h3_h3_is_res_class_iii | h3_h3_is_res_class_iii
---------------------+---------------------
 f                   | t
(1 row)
```

#### h3_h3_is_pentagon(h3index) returns boolean

Returns whether this represents a pentagonal cell.

```
SELECT h3_h3_is_pentagon(:hexagon), h3_h3_is_pentagon(:pentagon);
 h3_h3_is_pentagon | h3_h3_is_pentagon
----------------+----------------
 f              | t
(1 row)
```

### Grid traversal functions

#### h3_k_ring(h3index[, k]) returns setof h3index

Returns all hexes within `k` (default 1) distance of the origin `hex`, including itself.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indices, and so on.

Output is provided in no particular order.

```
SELECT h3_k_ring('880326b88dfffff');
   h3_k_ring
-----------------
 880326b88dfffff
 880326b8ebfffff
 880326b8e3fffff
 880326b885fffff
 880326b881fffff
 880326b889fffff
 880326b8c7fffff
(7 rows)
```

#### h3_k_ring_distances(h3index[, k]) returns setof h3indexDistance

Finds the set of all hexes within `k` (default 1) distance of the origin `hex` and their respective distances, including itself.

Output rows are provided in no particular order.

```
SELECT * FROM h3_k_ring_distances(:hexagon);
      index      | distance
-----------------+----------
 880326b88dfffff |        0
 880326b8ebfffff |        1
 880326b8e3fffff |        1
 880326b885fffff |        1
 880326b881fffff |        1
 880326b889fffff |        1
 880326b8c7fffff |        1
(7 rows)
```

#### h3_hex_range(h3index[, k]) returns setof h3index

Returns all hexes within `k` (default 1) distance of the origin `hex`, including itself.

Output is sorted in increasing distance from origin.
Will report an error if it encounters a pentagon, in this case use k_ring.

```
SELECT h3_hex_range(:hexagon);
    h3_hex_range
-----------------
 880326b88dfffff
 880326b8ebfffff
 880326b8e3fffff
 880326b885fffff
 880326b881fffff
 880326b889fffff
 880326b8c7fffff
(7 rows)
```

#### h3_hex_range_distances(h3index[, k]) returns setof h3indexDistance

Finds the set of all hexes within `k` (default 1) distance of the origin `hex` and their respective distances, including itself.

Output is sorted in increasing distance from origin.
Will report an error if it encounters a pentagon, in this case use h3_k_ring.

```
SELECT * FROM h3_hex_range_distances(:hexagon);
      index      | distance
-----------------+----------
 880326b88dfffff |        0
 880326b8ebfffff |        1
 880326b8e3fffff |        1
 880326b885fffff |        1
 880326b881fffff |        1
 880326b889fffff |        1
 880326b8c7fffff |        1
(7 rows)
```

#### h3_hex_ranges(ARRAY h3index[, k]) returns setof h3index

Returns all hexes within `k` (default 1) distance of every hex in the given array, including themselves.

Output is sorted in first by increasing order of elements in the array, secondly by distance of the particular element.
Will report an error if it encounters a pentagon.

```
SELECT h3_hex_range(:hexagon), h3_hex_range('880326b8ebfffff'), h3_hex_ranges('{880326b88dfffff,880326b8ebfffff}'::h3index[]);
    h3_hex_range    |    h3_hex_range    |   h3_hex_ranges
-----------------+-----------------+-----------------
 880326b88dfffff | 880326b8ebfffff | 880326b88dfffff
 880326b8ebfffff | 880326b8e9fffff | 880326b8ebfffff
 880326b8e3fffff | 880326b8e1fffff | 880326b8e3fffff
 880326b885fffff | 880326b8e3fffff | 880326b885fffff
 880326b881fffff | 880326b88dfffff | 880326b881fffff
 880326b889fffff | 880326b8c7fffff | 880326b889fffff
 880326b8c7fffff | 880326b8c5fffff | 880326b8c7fffff
                 |                 | 880326b8ebfffff
                 |                 | 880326b8e9fffff
                 |                 | 880326b8e1fffff
                 |                 | 880326b8e3fffff
                 |                 | 880326b88dfffff
                 |                 | 880326b8c7fffff
                 |                 | 880326b8c5fffff
(14 rows)
```

#### h3_hex_ring(h3index[, k]) returns setof h3index

Returns the hollow ring of hexes with `k` (default 1) distance of the origin `hex`.

Will report an error if it encounters a pentagon, in this case use h3_k_ring.

```
SELECT h3_hex_ring(:hexagon, 2);
    h3_hex_ring
-----------------
 880326b8c1fffff
 880326b8c5fffff
 880326b8e9fffff
 880326b8e1fffff
 880326b8e7fffff
 880326b8a9fffff
 880326b8abfffff
 880326b887fffff
 880326b883fffff
 880326b88bfffff
 880326b8d5fffff
 880326b8c3fffff
(12 rows)
```

#### h3_distance(h3index, h3index) returns int

Determines the distance in grid cells between the two given indices.

```
SELECT h3_distance('880326b881fffff', '880326b885fffff');
 h3_distance
-------------
           1
(1 row)
```

EXPERIMENTALS

### Hierarchical grid functions

#### h3_h3_to_parent(h3index[, parentRes]) returns h3index

Returns the parent (coarser) hex containing this `hex` at given `parentRes` (if no resolution is given, parent at current resolution minus one is found).

```
SELECT h3_h3_to_parent('880326b88dfffff', 5);
     h3_h3_to_parent
-----------------
 850326bbfffffff
(1 row)
```

#### h3_h3_to_children(h3index[, childRes]) returns setof h3index

Returns all hexes contained by `hex` at given `childRes` (if no resolution is given, children at current resolution plus one is found).

May cause problems with too large memory allocations. Please see `h3_h3_to_children_slow`.

```
SELECT h3_h3_to_children('880326b88dfffff', 9);
    h3_h3_to_children
-----------------
 890326b88c3ffff
 890326b88c7ffff
 890326b88cbffff
 890326b88cfffff
 890326b88d3ffff
 890326b88d7ffff
 890326b88dbffff
(7 rows)
```

#### h3_h3_to_children_slow(h3index[, childRes]) returns setof h3index

This functions does the same as `h3_h3_to_children_slow` but allocates smaller chunks of memory at the cost speed.

#### h3_compact(h3index[]) returns setof h3index

Returns the compacted version of the input array. I.e. if all children of an hex is included in the array, these will be compacted into the parent hex.

```
SELECT h3_compact(array_cat(ARRAY(SELECT h3_h3_to_children('880326b88dfffff')), ARRAY(SELECT h3_h3_to_children('880326b88bfffff'))));
   h3_compact
-----------------
 880326b88bfffff
 880326b88dfffff
(2 rows)
```

#### h3_uncompact(ARRAY h3index[, resolution]) returns setof h3index

Uncompacts the given hex array at the given resolution. If no resolution it will be chosen to be the highest resolution of the given indexes + 1.

```
SELECT h3_uncompact(array_cat(ARRAY(SELECT h3_h3_to_parent('880326b88dfffff')), '{880326b88bfffff}'::h3index[]));
  h3_uncompact
-----------------
 890326b8803ffff
 890326b8807ffff
 890326b880bffff
 890326b880fffff
 890326b8813ffff
 890326b8817ffff
 890326b881bffff
 890326b8823ffff
 890326b8827ffff
 890326b882bffff
 890326b882fffff
 890326b8833ffff
 890326b8837ffff
 890326b883bffff
 890326b8843ffff
 890326b8847ffff
 890326b884bffff
 890326b884fffff
 890326b8853ffff
 890326b8857ffff
 890326b885bffff
 890326b8863ffff
 890326b8867ffff
 890326b886bffff
 890326b886fffff
 890326b8873ffff
 890326b8877ffff
 890326b887bffff
 890326b8883ffff
 890326b8887ffff
 890326b888bffff
 890326b888fffff
 890326b8893ffff
 890326b8897ffff
 890326b889bffff
 890326b88a3ffff
 890326b88a7ffff
 890326b88abffff
 890326b88afffff
 890326b88b3ffff
 890326b88b7ffff
 890326b88bbffff
 890326b88c3ffff
 890326b88c7ffff
 890326b88cbffff
 890326b88cfffff
 890326b88d3ffff
 890326b88d7ffff
 890326b88dbffff
 890326b88a3ffff
 890326b88a7ffff
 890326b88abffff
 890326b88afffff
 890326b88b3ffff
 890326b88b7ffff
 890326b88bbffff
(56 rows)
```

### Region functions

#### h3_polyfill(exterior polygon, holes polygon[], resolution integer) returns setof h3index

Polyfill takes a given exterior native postgres polygon and an array of interior holes (also native polygons), along with a resolutions and fills it with hexagons that are contained.

```
SELECT h3_polyfill(exterior, holes, 1) FROM
(
 SELECT *  FROM h3_h3_set_to_linked_geo(ARRAY(SELECT h3_h3_to_children('8059fffffffffff, 1)))
) q;
   h3_polyfill
-----------------
 8158fffffffffff
 8159bffffffffff
 8158bffffffffff
 81597ffffffffff
 81587ffffffffff
 81593ffffffffff
 81583ffffffffff
(7 rows)
```

#### h3_h3_set_to_linked_geo(h3index[]) returns SET (exterior polygon, holes polygon[])

Create records of exteriors and holes.

```
SELECT h3_polyfill(exterior, holes, 1) FROM
(
 SELECT *  FROM h3_h3_set_to_linked_geo(ARRAY(SELECT h3_h3_to_children('8059fffffffffff, 1)))
) q;
   h3_polyfill
-----------------
 8158fffffffffff
 8159bffffffffff
 8158bffffffffff
 81597ffffffffff
 81587ffffffffff
 81593ffffffffff
 81583ffffffffff
(7 rows)
```

### Unidirectional Edges

Unidirectional edges are a form of H3Indexes that denote a unidirectional edge between two neighbouring indexes.

### h3_h3_indexes_are_neighbors(h3index, h3index) returns boolean

Determines whether or not the two indexes are neighbors. Returns true if they are and false if they aren't

```
SELECT h3_h3_indexes_are_neighbors(:hexagon, '880326b8ebfffff'), h3_h3_indexes_are_neighbors('880326b881fffff', '880326b8ebfffff');
 h3_h3_indexes_are_neighbors | h3_h3_indexes_are_neighbors
--------------------------+--------------------------
 t                        | f
(1 row)
```

#### h3_get_h3_unidirectional_edge(origin h3index, destination h3index) returns h3index

Returns the edge from origin to destination

Will error if the two indexes are not neighbouring

```
SELECT(h3_get_h3_unidirectional_edge(:hexagon, :neighbour));
 h3_get_h3_unidirectional_edge
----------------------------
 1180326b885fffff
(1 row)
```

#### h3_h3_unidirectional_edge_is_valid(h3index) returns boolean

Returns true if the given hex is a valid edge.

```
SELECT h3_h3_unidirectional_edge_is_valid(h3_get_h3_unidirectional_edge(:hexagon, :neighbour));
 h3_h3_unidirectional_edge_is_valid
---------------------------------
 t
(1 row)
```

#### h3_get_origin_h3_index_from_unidirectional_edge(h3index) returns h3index

Returns the origin index from the given edge

```
SELECT h3_get_origin_h3_index_from_unidirectional_edge(h3_get_h3_unidirectional_edge(:hexagon, :neighbour)), :hexagon;
 h3_get_origin_h3_index_from_unidirectional_edge |    ?column?
----------------------------------------------+-----------------
 880326b885fffff                              | 880326b885fffff
(1 row)
```

#### h3_get_destination_h3_index_from_unidirectional_edge(h3index) returns h3index

Returns the destination index from the given edge

```
SELECT h3_get_destination_h3_index_from_unidirectional_edge(h3_get_h3_unidirectional_edge(:hexagon, :neighbour)), :neighbour;
 h3_get_destination_h3_index_from_unidirectional_edge |    ?column?
---------------------------------------------------+-----------------
 880326b887fffff                                   | 880326b887fffff
(1 row)
```

#### h3_get_h3_indexes_from_unidirectional_edge(h3index) returns edgeIndexes (origin h3index, destination h3index)

Returns both the origin and destination indexes from the given edge

```
SELECT * FROM h3_get_h3_indexes_from_unidirectional_edge(h3_get_h3_unidirectional_edge(:hexagon, :neighbour));
     origin      |   destination
-----------------+-----------------
 880326b885fffff | 880326b887fffff
(1 row)
```

#### h3_get_h3_unidirectional_edges_from_hexagon(h3index) returns setof h3index

Returns the set of all valid unidirectional edges with the given origin

```
SELECT h3_get_h3_unidirectional_edges_from_hexagon(:hexagon);
 h3_get_h3_unidirectional_edges_from_hexagon
------------------------------------------
 1180326b885fffff
 1280326b885fffff
 1380326b885fffff
 1480326b885fffff
 1580326b885fffff
 1680326b885fffff
(6 rows)
```

#### h3_get_h3_unidirectional_edge_boundary(h3index) returns polygon

Find the boundary of this edge, in native PostgreSQL polygon type.

```
SELECT h3_get_unidirectional_edge_boundary(h3_get_h3_unidirectional_edge(:hexagon, :neighbour));
                     h3_get_unidirectional_edge_boundary
---------------------------------------------------------------------------
 ((89.5830164946548,64.7146398954916),(89.5790678021742,64.2872231517217))
(1 row)
```

### Miscellaneous

#### h3_degs_to_rads(float) returns float

Converts degrees to radians.

```
SELECT h3_rads_to_degs(degs_to_rads(90.45));
 h3_rads_to_degs
--------------
        90.45
(1 row)
```

#### h3_rads_to_degs(float) returns float

Converts radians to degrees.

```
SELECT h3_rads_to_degs(degs_to_rads(90.45));
 h3_rads_to_degs
--------------
        90.45
(1 row)
```

#### h3_hex_area_km2(resolution integer) returns float

Returns the area of an hex in square kilometers at the given resolution.

```
SELECT h3_hex_area_km2(10);
 h3_hex_area_km2
--------------
    0.0150475
(1 row)
```

#### h3_hex_area_m2(resolution integer) retuns float

Returns the area of an hex in square meters at the given resolution.

```
SELECT h3_hex_area_m2(10);
 h3_hex_area_m2
-------------
     15047.5
(1 row)
```

#### h3_edge_length_km(resolution integer) returns float

Returns the length of the edges of an hex in kilometers at the given resolution.

```
SELECT h3_edge_length_km(10);
 h3_edge_length_km
----------------
    0.065907807
(1 row)
```

#### h3_edge_length_m(resolution integer) returns float

Returns the length of the edges of an hex in meters at the given resolution.

```
SELECT h3_edge_length_m(10);
 h3_edge_length_m
---------------
   65.90780749
(1 row)
```

#### h3_num_hexagons(resolution integer) returns bigint

Returns the number of unique indexes at the given resolution

```
SELECT h3_num_hexagons(15);
  h3_num_hexagons
-----------------
 569707381193162
(1 row)
```

### PostGIS integration

We provide some simple wrappers for casting to PostGIS types.

#### h3_geo_to_h3(geometry / geography, resolution)

The `h3_geo_to_h3` function has been overloaded to support both PostGIS `geometry` and `geography`.

#### h3_h3_to_geometry(h3index) returns geometry

Finds the centroid of this hex as PostGIS geometry type.

```
SELECT h3_h3_to_geometry('8a63a9a99047fff');
                  h3_h3_to_geometry
----------------------------------------------------
 0101000020E61000008BE4AED877D54B40C46F27D42B2F2940
(1 row)
```

#### h3_h3_to_geography(h3index) returns geography

Same as above, but returns `geography` type.

#### h3_h3_to_geo_boundary_geometry(h3index) returns geometry

Find the boundary of this hex, as PostGIS type.

```
SELECT boundary_geometry('8a63a9a99047fff');
    boundary_geometry
-------------------------
 0103000020...FB70D54B40
(1 row)
```

#### h3_h3_to_geo_boundary_geography(h3index) returns geography

Same as above, but returns `geography` type.

### Custom functions

#### h3_basecells() returns setof h3index

Returns all hexes at coarsest resolution.

```
SELECT h3_basecells();
    h3_basecells
-----------------
 8001fffffffffff
 ...
 80f3fffffffffff
(122 rows)
```

#### haversine_distance(from h3index, to h3index) returns float

Determines the distance between `from_hex` and `to_hex`, based on [Haversine Distance](https://en.wikipedia.org/wiki/Haversine_formula).

```
SELECT h3_haversine_distance('8f2830828052d25', '8f283082a30e623');
 h3_haversine_distance
--------------------
   2.25685336707384
(1 row)
```
