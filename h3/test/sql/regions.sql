\pset tuples_only on
-- res 0 index
\set res0index '\'8059fffffffffff\''
-- center hex
\set center '\'81583ffffffffff\''
-- 7 child hexes in res 0 index
\set solid 'ARRAY(SELECT h3_to_children(:res0index, 1))'
-- 6 child hexes in rim of res 0 index
\set hollow 'array_remove(:solid, :center)'
-- polygon with 2 holes
\set with2holes '\'POLYGON((31.6520834 68.9912098,31.6521263 68.9910944,31.6530919 68.9912021,31.6540789 68.9912944,31.6550016 68.991279,31.6553449 68.9910175,31.6554737 68.9907713,31.6559458 68.990402,31.6563535 68.9900789,31.6568684 68.9897404,31.6569543 68.9895711,31.6567182 68.988671,31.6569114 68.9881786,31.6571045 68.9879401,31.6567611 68.9875708,31.6570401 68.9873015,31.6576195 68.986986,31.6581774 68.9868398,31.6584992 68.9870553,31.6586065 68.9872707,31.6590786 68.9873246,31.6594219 68.9872091,31.6596579 68.9870091,31.6596579 68.9867706,31.6601515 68.9866167,31.6607308 68.9864551,31.660409 68.986232,31.6601729 68.9860627,31.6605806 68.9859319,31.6614818 68.9859011,31.6620183 68.9857087,31.6622972 68.9854471,31.6628337 68.9852932,31.6633701 68.9852855,31.663928 68.9855702,31.6640782 68.9859088,31.6636705 68.9862166,31.6639924 68.9864859,31.664443 68.9868629,31.664679 68.9872091,31.6642928 68.9873784,31.6641426 68.9876939,31.6650009 68.9879016,31.6652155 68.9881555,31.6653657 68.9883709,31.6659665 68.9886941,31.6662884 68.9889941,31.666739 68.989248,31.6669321 68.9891095,31.6670394 68.9888787,31.6681123 68.9889326,31.6687345 68.989325,31.6692495 68.9895865,31.6701937 68.9897635,31.6710949 68.9897404,31.6725325 68.9897558,31.6733479 68.9898558,31.6743135 68.9904097,31.674571 68.990702,31.6747641 68.9909328,31.6745066 68.9911405,31.6738844 68.9912636,31.6731977 68.9914175,31.6734981 68.9916098,31.6739487 68.9915713,31.6744852 68.9915175,31.6750431 68.9914021,31.6751718 68.9911944,31.6752147 68.9910405,31.6756439 68.9910636,31.6765451 68.9912021,31.6777253 68.9912944,31.6784119 68.9912482,31.6790771 68.9911559,31.6793346 68.9913021,31.6787553 68.9916713,31.678133 68.9920867,31.6780472 68.9924483,31.6782617 68.9927098,31.6792702 68.9941098,31.6794419 68.9943636,31.6801715 68.9945328,31.6817808 68.9946328,31.6825533 68.9948174,31.6827249 68.995202,31.683712 68.9957404,31.6840124 68.9962634,31.684699 68.9965556,31.6848492 68.9968171,31.6841197 68.9969632,31.6831326 68.9969479,31.6827464 68.9969171,31.6824031 68.9968556,31.6821456 68.9967248,31.6813302 68.9968248,31.6810083 68.9971094,31.6806865 68.9971863,31.6802358 68.9971401,31.6792702 68.9967018,31.6787553 68.9963864,31.6780901 68.9958327,31.6777038 68.9956788,31.6766095 68.9955635,31.6762233 68.9954943,31.6759658 68.9952943,31.6753649 68.9951481,31.6746354 68.9952712,31.6735625 68.9951866,31.6728329 68.9951866,31.6726398 68.9953943,31.6719746 68.9955173,31.6709661 68.9954173,31.6704941 68.9951558,31.6700434 68.9948251,31.669743 68.9944867,31.6695285 68.994179,31.6693783 68.9939329,31.6690779 68.993756,31.6680479 68.9935867,31.663692 68.9929329,31.6628551 68.9927637,31.661675 68.9927637,31.6610527 68.9929637,31.6605377 68.9929714,31.6599583 68.9929406,31.6588855 68.9928175,31.658349 68.992656,31.657598 68.9923714,31.6567826 68.9922329,31.6552162 68.9920714,31.6541648 68.9919175,31.6531348 68.9916483,31.6523838 68.9914175,31.6520834 68.9912098),(31.657185 68.990202,31.657244 68.9903482,31.6574585 68.9903809,31.6578555 68.9903597,31.6581452 68.9902539,31.6583651 68.9900924,31.6582364 68.9899366,31.6578716 68.9898616,31.6575766 68.9898731,31.6573083 68.9899808,31.6572332 68.9900731,31.657185 68.990202),(31.6590196 68.9886094,31.6591644 68.9887229,31.6594058 68.9888537,31.6595936 68.9889557,31.6596794 68.9890441,31.6597116 68.9891345,31.659776 68.9892519,31.6599476 68.9891903,31.660012 68.9890614,31.6601139 68.9889383,31.6602641 68.9888326,31.6602749 68.988721,31.6601998 68.988596,31.6600603 68.988369,31.6601676 68.9882709,31.6604251 68.9882844,31.6607255 68.9882728,31.6609454 68.9881767,31.6605592 68.9880901,31.6604841 68.9879689,31.6603607 68.9878497,31.660071 68.9878843,31.6597867 68.9879959,31.6593575 68.9880305,31.6592127 68.9881132,31.6592234 68.9882421,31.6592127 68.9883786,31.6590196 68.9886094))\''::geometry(POLYGON)
-- pentagon
\set pentagon '\'831c00fffffffff\'::h3index'

--
-- TEST h3_polyfill and h3_set_to_multi_polygon
--

-- h3_polyfill is inverse of h3_set_to_multi_polygon for set without holes
SELECT array_agg(result) is null FROM (
    SELECT h3_polyfill(exterior, holes, 1) result FROM (
        SELECT exterior, holes FROM h3_set_to_multi_polygon(:solid)
    ) qq
    EXCEPT SELECT unnest(:solid) result
) q;

-- h3_polyfill is inverse of h3_set_to_multi_polygon for set with a hole
SELECT array_agg(result) is null FROM (
    SELECT h3_polyfill(exterior, holes, 1) result FROM (
        SELECT exterior, holes FROM h3_set_to_multi_polygon(:hollow)
    ) qq
    EXCEPT SELECT unnest(:hollow) result
) q;

-- h3_polyfill works for polygon with two holes
SELECT COUNT(*) = 48 FROM (
    SELECT h3_polyfill(:with2holes, 10)
) q;

-- h3_polyfill doesn't segfault on NULL value in holes
SELECT TRUE FROM (
    SELECT h3_polyfill(exterior, ARRAY[NULL::POLYGON], 1) result FROM (
        SELECT exterior, holes FROM h3_set_to_multi_polygon(
            ARRAY[:pentagon]::H3Index[]
        )
    ) qq
) q LIMIT 1;

-- h3_polyfill throws on non-polygons
CREATE FUNCTION h3_test_polyfill_bad1() RETURNS boolean LANGUAGE PLPGSQL
    AS $$
        BEGIN
            PERFORM h3_polyfill(ST_GeomFromText('POINT(-71.160281 42.258729)',4326), 8);
            RETURN false;
        EXCEPTION WHEN OTHERS THEN
            RETURN true;
        END;
    $$;
CREATE FUNCTION h3_test_polyfill_bad2() RETURNS boolean LANGUAGE PLPGSQL
    AS $$
        BEGIN
            PERFORM h3_polyfill(ST_GeomFromText('LINESTRING(-71.160281 42.258729,-71.160837 42.259113,-71.161144 42.25932)',4326), 8);
            RETURN false;
        EXCEPTION WHEN OTHERS THEN
            RETURN true;
        END;
    $$;
SELECT h3_test_polyfill_bad1();
SELECT h3_test_polyfill_bad2();
DROP FUNCTION h3_test_polyfill_bad1;
DROP FUNCTION h3_test_polyfill_bad2;