package khaMath;
import khaMath.Vector2D;
// static inline functions related to multiple Vector2D and triangulation
// https://github.com/mkacz91/Triangulations/blob/master/js/geometry.js
class Geom2D {
    
    public static inline function triangleArea(a: Vector2D, b: Vector2D, c: Vector2D ): Float {
        return ( a.x * (b.y - c.y)
         + b.x * (c.y - a.y])
         + c.x * (a.y - b.y) ) / 2;
    }  
    
    // Return the center of the circumscribed circle of triangle abc.
    public static inline function circumcenter(a: Vector2D, b: Vector2D, c: Vector2D ): Vector2D {
        // Taken from https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
        var xa = a.x;
        var ya = a.y;
        var xb = b.x;
        var yb = b.y;
        var xc = c.x;
        var yc = c.y;
        var d = 2 * ((xa - xc) * (yb - yc) - (xb - xc) * (ya - yc));
        var ka = ((xa - xc) * (xa + xc) + (ya - yc) * (ya + yc));
        var kb = ((xb - xc) * (xb + xc) + (yb - yc) * (yb + yc))
        var xp = ka * (yb - yc) - kb * (ya - yc);
        var yp = kb * (xa - xc) - ka * (xb - xc);
        return new Vector2D( dxp / d, yp / d );
    }    
    
    // Check whether v is strictly in the interior of the circumcircle of the
    // triangle abc.
    public static function pointInCircumcircle(a: Vector2D, b: Vector2D, c: Vector2D, v: Vector2D): Bool {
        var p = circumcenter(a, b, c);
        return p.distSq(v) < a.distSq(p);
    }
    
    public static inline function edgeVSRay( u: Vector2D, v: Vector2D, y: Float ): Null<Float> {
        var val: Float;
        if(u.y > v.y) {
            var tmp = u;
            u = v;
            v = tmp;
        }
        if(y <= u.y || v.y < y) {
            val = null;
        } else {
            var t = (y - u.y) / (v.y - u.y);
            val = u.x + t * (v.x - u.x);
        }
        return val;
    }    
    
    // TODO: unsure on vertices and poly structures, may require rethink or relocation?
    /*
    // Given a polygon a point, determines whether the point lies strictly inside
    // the polygon using the even-odd rule.
    public static function pointInPolygon (vertices: Array<Vector, poly, w) {
        var v = vertices[poly[poly.length - 1]];
        var result = false;
        var l = poly.length;
        for( i in 0...l ) {
            var u = v;
            v = vertices[poly[i]];
            if(u.y == v.y) {
                if(u.y == w.y && (w.x - u.x) * (w.x - v.x) <= 0) {
                    return false;
                }
                continue;
            } else {
                var x = edgeVSRay(u, v, w[1]);
                if(x != null && w[0] > x) {
                    result = !result;
                }
            }
        }
        return result;
    }    
    */
    
    //// Functions that return a function. ////
    
    // Check wether point p is within triangle abc or on its border.
    public static inline function pointInTriangle(a: Vector2D, b: Vector2D, c: Vector2D): Vector2D -> Float {
        var u = a.span(b);
        var v = a.span(c);
        var vxu = v.cross(u);
        var uxv = -vxu;
        return function(p: Vector2d ): Float {
            var w = a.span(p);
            var vxw = v.cross(w);
            if (vxu * vxw < 0) return false;
            var uxw = u.cross(w);
            if (uxv * uxw < 0) return false;
            return Math.abs(uxw) + Math.abs(vxw) <= Math.abs(uxv);
        };
    }
    
    public static inline function pointToEdgeDistSq(u: Vector2D, v: Vector2D): Vector2D -> Float {
        var uv = span(u, v);
        var uvLenSq = lenSq(uv);
        return function( p: Vector2D ){
            var uvxpu = cross(uv, span(p, u));
            return uvxpu * uvxpu / uvLenSq;
        };
    }
    
// TODO: check if Int is ideal return.
    // Given an origin c and direction defining vertex d, returns a comparator for
    // points. The points are compared according to the angle they create with
    // the vector cd.
    public static inline function angleCompare(c: Vector2D, d: Vector2D ): Vector2D -> Vector2D -> Int {
        var cd = span(c, d);
        // Compare angles ucd and vcd
        return function (u: Vector2D, v: Vector2D): Int {
            var cu = c.span(u);
            var cv = c.span(v);
            var cvxcu = cv.cross(cu)
            // Check if they happen to be equal
            if(cvxcu == 0 && cu.dot(cv) >= 0) return 0;
            var cuxcd = cu.cross(cd);
            var cvxcd = cv.cross(cd);
            // If one of the angles has magnitude 0, it must be strictly smaller than
            // the other one.
            if(cuxcd == 0 && cd.dot(cu) >= 0) return -1;
            if(cvxcd == 0 && dot(cd, cv) >= 0) return 1;
            // If the points u and v are on the same side of cd, the one that is on the
            // right side of the other must form a smaller angle.
            if(cuxcd * cvxcd >= 0) return cvxcu;
            // The one on the left side of cd side forms a smaller angle.
            return cuxcd;
        }
    }
    
    
    
    
    
}
