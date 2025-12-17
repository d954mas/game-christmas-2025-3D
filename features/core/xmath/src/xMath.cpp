#define LIB_NAME "xmath"
#define MODULE_NAME "xmath"
#define DLIB_LOG_DOMAIN "xMath"

#include <dmsdk/dlib/transform.h>
#include <dmsdk/sdk.h>

#define M_PI_2 1.57079632679489661923

#define DEG_FACTOR 57.295779513f

inline dmVMath::Vector3 QuatToEuler(float q0, float q1, float q2, float q3) {
    // Early-out when the rotation axis is either X, Y or Z.
    // The reasons we make this distinction is that one-axis rotation is common (and cheaper), especially around Z in 2D games
    uint8_t mask = (q2 != 0.f) << 2 | (q1 != 0.f) << 1 | (q0 != 0.f);
    switch (mask) {
    case 0b000:
        return dmVMath::Vector3(0.0f, 0.0f, 0.0f);
    case 0b001:
    case 0b010:
    case 0b100: {
        dmVMath::Vector3 r(0.0f, 0.0f, 0.0f);
        // the sum of the values yields one value, as the others are 0
        r.setElem(mask >> 1, atan2f(q0 + q1 + q2, q3) * 2.0f * DEG_FACTOR);
        return r;
    }
    }
    // Implementation based on:
    // * http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    // * http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/
    // * http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/Quaternions.pdf
    const float limit = 0.4999f; // gimbal lock limit, corresponds to 88.85 degrees
    float r0, r1, r2;
    float test = q0 * q1 + q2 * q3;
    if (test > limit) {
        r1 = 2.0f * atan2f(q0, q3);
        r2 = (float)M_PI_2;
        r0 = 0.0f;
    } else if (test < -limit) {
        r1 = -2.0f * atan2f(q0, q3);
        r2 = (float)-M_PI_2;
        r0 = 0.0f;
    } else {
        float sq0 = q0 * q0;
        float sq1 = q1 * q1;
        float sq2 = q2 * q2;
        r1 = atan2f(2.0f * q1 * q3 - 2.0f * q0 * q2, 1.0f - 2.0f * sq1 - 2.0f * sq2);
        r2 = asinf(2.0f * test);
        r0 = atan2f(2.0f * q0 * q3 - 2.0f * q1 * q2, 1.0f - 2.0f * sq0 - 2.0f * sq2);
    }
    return dmVMath::Vector3(r0, r1, r2) * DEG_FACTOR;
}
#undef DEG_FACTOR

#define HALF_RAD_FACTOR 0.008726646f

/**
 * Converts euler angles (x, y, z) in degrees into a quaternion
 * The error is guaranteed to be less than 0.001.
 * @param x rotation around x-axis (deg)
 * @param y rotation around y-axis (deg)
 * @param z rotation around z-axis (deg)
 * @result Quat describing an equivalent rotation (231 (YZX) rotation sequence).
 */
inline dmVMath::Quat EulerToQuat(dmVMath::Vector3 xyz) {
    // Early-out when the rotation axis is either X, Y or Z.
    // The reasons we make this distinction is that one-axis rotation is common (and cheaper), especially around Z in 2D games
    uint8_t mask = (xyz.getZ() != 0.f) << 2 | (xyz.getY() != 0.f) << 1 | (xyz.getX() != 0.f);
    switch (mask) {
    case 0b000:
        return dmVMath::Quat(0.0f, 0.0f, 0.0f, 1.0f);
    case 0b001:
    case 0b010:
    case 0b100: {
        // the sum of the angles yields one angle, as the others are 0
        float ha = (xyz.getX() + xyz.getY() + xyz.getZ()) * HALF_RAD_FACTOR;
        dmVMath::Quat q(0.0f, 0.0f, 0.0f, cos(ha));
        q.setElem(mask >> 1, sin(ha));
        return q;
    }
    }
    // Implementation based on:
    // http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19770024290.pdf
    // Rotation sequence: 231 (YZX)
    float t1 = xyz.getY() * HALF_RAD_FACTOR;
    float t2 = xyz.getZ() * HALF_RAD_FACTOR;
    float t3 = xyz.getX() * HALF_RAD_FACTOR;

    float c1 = cos(t1);
    float s1 = sin(t1);
    float c2 = cos(t2);
    float s2 = sin(t2);
    float c3 = cos(t3);
    float s3 = sin(t3);
    float c1_c2 = c1 * c2;
    float s2_s3 = s2 * s3;

    dmVMath::Quat quat;
    quat.setW(-s1 * s2_s3 + c1_c2 * c3);
    quat.setX(s1 * s2 * c3 + s3 * c1_c2);
    quat.setY(s1 * c2 * c3 + s2_s3 * c1);
    quat.setZ(-s1 * s3 * c2 + s2 * c1 * c3);
    return quat;
}

#undef HALF_RAD_FACTOR

//* Arithmetic
//* ----------------------------------------------------------------------------

static int xMath_add(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 3);
        *out = *lhs + *rhs;
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 2);
        Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 3);
        *out = *lhs + *rhs;
    }

    return 0;
}

static int xMath_sub(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 3);
        *out = *lhs - *rhs;
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 2);
        Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 3);
        *out = *lhs - *rhs;
    }

    return 0;
}

static int xMath_mul(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        float rhs = (float)luaL_checknumber(L, 3);
        *out = *lhs * rhs;
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 2);
        float rhs = (float)luaL_checknumber(L, 3);
        *out = *lhs * rhs;
    }

    return 0;
}

static int xMath_div(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        float rhs = (float)luaL_checknumber(L, 3);
        *out = *lhs / rhs;
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 2);
        float rhs = (float)luaL_checknumber(L, 3);
        *out = *lhs / rhs;
    }

    return 0;
}

//* Vector
//* ----------------------------------------------------------------------------

static int xMath_cross(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 3);
        *out = Vectormath::Aos::cross(*lhs, *rhs);
    }

    return 0;
}

static int xMath_mul_per_elem(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 3);
        *out = Vectormath::Aos::mulPerElem(*lhs, *rhs);
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 2);
        Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 3);
        *out = Vectormath::Aos::mulPerElem(*lhs, *rhs);
    }

    return 0;
}

static int xMath_normalize(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Vector3 *a = dmScript::CheckVector3(L, 2);
        *out = Vectormath::Aos::normalize(*a);
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        Vectormath::Aos::Vector4 *a = dmScript::CheckVector4(L, 2);
        *out = Vectormath::Aos::normalize(*a);
    }

    return 0;
}

static int xMath_rotate(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Quat *lhs = dmScript::CheckQuat(L, 2);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 3);
        *out = Vectormath::Aos::rotate(*lhs, *rhs);
    }

    return 0;
}

static int xMath_vector(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        if (dmScript::IsVector3(L, 2)) {
            *out = *dmScript::CheckVector3(L, 2);
        } else {
            *out = Vectormath::Aos::Vector3(0, 0, 0);
        }

    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        if (dmScript::IsVector4(L, 2)) {
            *out = *dmScript::CheckVector4(L, 2);
        } else {
            *out = Vectormath::Aos::Vector4(0, 0, 0, 1);
        }
    }

    return 0;
}

//* Vector3
//* ----------------------------------------------------------------------------
static int xMath_vector3_set_components(lua_State *L) {
    Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    float z = luaL_checknumber(L, 4);
    *out = Vectormath::Aos::Vector3(x, y, z);
    return 0;
}

static int xMath_vector4_set_components(lua_State *L) {
    Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    float z = luaL_checknumber(L, 4);
    float w = luaL_checknumber(L, 5);
    *out = Vectormath::Aos::Vector4(x, y, z, w);
    return 0;
}

//* Quat
//* ----------------------------------------------------------------------------

static int xMath_conj(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Quat *a = dmScript::CheckQuat(L, 2);
        *out = Vectormath::Aos::conj(*a);
    }

    return 0;
}

static int xMath_quat_axis_angle(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Vector3 *axis = dmScript::CheckVector3(L, 2);
        float angle = (float)luaL_checknumber(L, 3);
        *out = Vectormath::Aos::Quat(*axis, angle);
    }

    return 0;
}

static int xMath_quat_basis(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Vector3 *x = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *y = dmScript::CheckVector3(L, 3);
        Vectormath::Aos::Vector3 *z = dmScript::CheckVector3(L, 4);
        Vectormath::Aos::Matrix3 m;
        m.setCol0(*x);
        m.setCol1(*y);
        m.setCol2(*z);
        *out = Vectormath::Aos::Quat(m);
    }

    return 0;
}

static int xMath_quat_from_to(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Vector3 *from = dmScript::CheckVector3(L, 2);
        Vectormath::Aos::Vector3 *to = dmScript::CheckVector3(L, 3);
        *out = Vectormath::Aos::Quat::rotation(*from, *to);
    }

    return 0;
}

static int xMath_quat_rotation_x(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::ToQuat(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Quat::rotationX(angle);
    }

    return 0;
}

static int xMath_quat_rotation_y(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::ToQuat(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Quat::rotationY(angle);
    }

    return 0;
}

static int xMath_quat_rotation_z(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::ToQuat(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Quat::rotationZ(angle);
    }

    return 0;
}

static int xMath_quat(lua_State *L) {
    if (dmScript::IsQuat(L, 1) && dmScript::IsQuat(L, 2)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Quat *in = dmScript::CheckQuat(L, 2);
        *out = *in;
    } else if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        *out = Vectormath::Aos::Quat::identity();
    }

    return 0;
}


static int xMath_quat_reverse(lua_State *L) {
    if (dmScript::IsQuat(L, 1) && dmScript::IsQuat(L, 2)) {
        Vectormath::Aos::Quat *out = dmScript::ToQuat(L, 1);
        Vectormath::Aos::Quat *in = dmScript::ToQuat(L, 2);
        out->setX(-in->getX());
        out->setY(-in->getY());
        out->setZ(-in->getZ());
        out->setW(in->getW());
    }else{
        luaL_error(L, "Invalid arguments to quat_reverse");
    }
    return 0;
}

static int xMath_quat_mul(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        Vectormath::Aos::Quat *lhs = dmScript::CheckQuat(L, 2);
        Vectormath::Aos::Quat *rhs = dmScript::CheckQuat(L, 3);
        *out = *lhs * *rhs;
    }
    return 0;
}

static int xMath_quat_to_euler(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        Vectormath::Aos::Quat *q = dmScript::CheckQuat(L, 2);
        *out = QuatToEuler(q->getX(), q->getY(), q->getZ(), q->getW());
    }
    return 0;
}

static int xMath_euler_to_quat(lua_State *L) {
    if (dmScript::IsQuat(L, 1)) {
        dmVMath::Quat *out = dmScript::ToQuat(L, 1);
        dmVMath::Vector3 *v = dmScript::CheckVector3(L, 2);
        *out = EulerToQuat(*v);
    }
    return 0;
}

//* Vector + Quat
//* ----------------------------------------------------------------------------

static int xMath_lerp(lua_State *L) {
    if (lua_isnumber(L, 1)) {
        float out = luaL_checknumber(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        float lhs = (float)luaL_checknumber(L, 3);
        float rhs = (float)luaL_checknumber(L, 4);
        out = (lhs + ((rhs - lhs) * t));
    } else if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 3);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 4);
        *out = Vectormath::Aos::lerp(t, *lhs, *rhs);
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 3);
        Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 4);
        *out = Vectormath::Aos::lerp(t, *lhs, *rhs);
    } else if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Quat *lhs = dmScript::CheckQuat(L, 3);
        Vectormath::Aos::Quat *rhs = dmScript::CheckQuat(L, 4);
        *out = Vectormath::Aos::slerp(t, *lhs, *rhs);
    }

    return 0;
}

static int xMath_slerp(lua_State *L) {
    if (dmScript::IsVector3(L, 1)) {
        Vectormath::Aos::Vector3 *out = dmScript::CheckVector3(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Vector3 *lhs = dmScript::CheckVector3(L, 3);
        Vectormath::Aos::Vector3 *rhs = dmScript::CheckVector3(L, 4);
        *out = Vectormath::Aos::slerp(t, *lhs, *rhs);
    } else if (dmScript::IsVector4(L, 1)) {
        Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Vector4 *lhs = dmScript::CheckVector4(L, 3);
        Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 4);
        *out = Vectormath::Aos::slerp(t, *lhs, *rhs);
    } else if (dmScript::IsQuat(L, 1)) {
        Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 1);
        float t = (float)luaL_checknumber(L, 2);
        Vectormath::Aos::Quat *lhs = dmScript::CheckQuat(L, 3);
        Vectormath::Aos::Quat *rhs = dmScript::CheckQuat(L, 4);
        *out = Vectormath::Aos::slerp(t, *lhs, *rhs);
    }

    return 0;
}

//* Matrix
//* ----------------------------------------------------------------------------

static int xMath_matrix(lua_State *L) {
    if (lua_gettop(L) == 0 && dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        *out = Vectormath::Aos::Matrix4::identity();
    } else if (lua_gettop(L) == 1 && dmScript::IsMatrix4(L, 1) && dmScript::IsMatrix4(L, 2)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Matrix4 *in = dmScript::CheckMatrix4(L, 1);
        *out = *in;
    }

    return 0;
}

static int xMath_matrix_mul(lua_State *L) {
    Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
    Vectormath::Aos::Matrix4 *lhs = dmScript::CheckMatrix4(L, 2);
    Vectormath::Aos::Matrix4 *rhs = dmScript::CheckMatrix4(L, 3);
    *out = *lhs * *rhs;
    return 0;
}

static int xMath_matrix_mul_v4(lua_State *L) {
    Vectormath::Aos::Vector4 *out = dmScript::CheckVector4(L, 1);
    Vectormath::Aos::Matrix4 *lhs = dmScript::CheckMatrix4(L, 2);
    Vectormath::Aos::Vector4 *rhs = dmScript::CheckVector4(L, 3);
    *out = *lhs * *rhs;
    return 0;
}

static int xMath_matrix_transpose(lua_State *L) {
    Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
    Vectormath::Aos::Matrix4 lhs = *dmScript::CheckMatrix4(L, 2);

    Vectormath::Aos::Matrix4 out2 = *out;

    out2[0][0] = lhs[0][0];
    out2[0][1] = lhs[1][0];
    out2[0][2] = lhs[2][0];
    out2[0][3] = lhs[3][0];

    out2[1][0] = lhs[0][1];
    out2[1][1] = lhs[1][1];
    out2[1][2] = lhs[2][1];
    out2[1][3] = lhs[3][1];

    out2[2][0] = lhs[0][2];
    out2[2][1] = lhs[1][2];
    out2[2][2] = lhs[2][2];
    out2[2][3] = lhs[3][2];

    out2[3][0] = lhs[0][3];
    out2[3][1] = lhs[1][3];
    out2[3][2] = lhs[2][3];
    out2[3][3] = lhs[3][3];

    *out = out2;
    return 0;
}

static int xMath_matrix_axis_angle(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Vector3 *axis = dmScript::CheckVector3(L, 2);
        float angle = (float)luaL_checknumber(L, 3);
        *out = Vectormath::Aos::Matrix4::rotation(angle, *axis);
    }

    return 0;
}

static int xMath_matrix_from_quat(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Quat *quat = dmScript::CheckQuat(L, 2);
        *out = Vectormath::Aos::Matrix4::rotation(*quat);
    }

    return 0;
}

static int xMath_matrix_frustum(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float left = (float)luaL_checknumber(L, 2);
        float right = (float)luaL_checknumber(L, 3);
        float bottom = (float)luaL_checknumber(L, 4);
        float top = (float)luaL_checknumber(L, 5);
        float near_z = (float)luaL_checknumber(L, 6);
        if (near_z == 0.0f)
            near_z = 0.00001f;
        float far_z = (float)luaL_checknumber(L, 7);
        *out = Vectormath::Aos::Matrix4::frustum(left, right, bottom, top, near_z, far_z);
    }

    return 0;
}

static int xMath_matrix_inv(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Matrix4 *in = dmScript::CheckMatrix4(L, 2);
        *out = Vectormath::Aos::inverse(*in);
    }
    return 0;
}

static int xMath_matrix_from_matrix(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Matrix4 *in = dmScript::CheckMatrix4(L, 2);
        *out = *in;
    }
    return 0;
}

static int xMath_matrix_look_at(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Point3 eye = Vectormath::Aos::Point3(*dmScript::CheckVector3(L, 2));
        Vectormath::Aos::Point3 target = Vectormath::Aos::Point3(*dmScript::CheckVector3(L, 3));
        Vectormath::Aos::Vector3 up = *dmScript::CheckVector3(L, 4);
        *out = Vectormath::Aos::Matrix4::lookAt(eye, target, up);
    }

    return 0;
}

static int xMath_matrix_orthographic(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float left = (float)luaL_checknumber(L, 2);
        float right = (float)luaL_checknumber(L, 3);
        float bottom = (float)luaL_checknumber(L, 4);
        float top = (float)luaL_checknumber(L, 5);
        float near_z = (float)luaL_checknumber(L, 6);
        float far_z = (float)luaL_checknumber(L, 7);
        *out = Vectormath::Aos::Matrix4::orthographic(left, right, bottom, top, near_z, far_z);
    }

    return 0;
}

static int xMath_matrix_ortho_inv(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        Vectormath::Aos::Matrix4 *in = dmScript::CheckMatrix4(L, 2);
        *out = Vectormath::Aos::orthoInverse(*in);
    }

    return 0;
}

static int xMath_matrix_perspective(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float fov = (float)luaL_checknumber(L, 2);
        float aspect = (float)luaL_checknumber(L, 3);
        float near_z = (float)luaL_checknumber(L, 4);
        float far_z = (float)luaL_checknumber(L, 5);
        if (near_z == 0.0f)
            near_z = 0.00001f;
        *out = Vectormath::Aos::Matrix4::perspective(fov, aspect, near_z, far_z);
    }

    return 0;
}

static int xMath_matrix_rotation_x(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Matrix4::rotationX(angle);
    }

    return 0;
}

static int xMath_matrix_rotation_y(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Matrix4::rotationY(angle);
    }

    return 0;
}

static int xMath_matrix_rotation_z(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        float angle = (float)luaL_checknumber(L, 2);
        *out = Vectormath::Aos::Matrix4::rotationZ(angle);
    }

    return 0;
}

static int xMath_matrix_translation(lua_State *L) {
    if (dmScript::IsMatrix4(L, 1)) {
        Vectormath::Aos::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
        if (dmScript::IsVector3(L, 2)) {
            Vectormath::Aos::Vector3 *v = dmScript::CheckVector3(L, 2);
            *out = Vectormath::Aos::Matrix4::translation(*v);
        } else if (dmScript::IsVector4(L, 2)) {
            Vectormath::Aos::Vector4 *v = dmScript::CheckVector4(L, 2);
            *out = Vectormath::Aos::Matrix4::translation(v->getXYZ());
        }
    }
    return 0;
}

static int xMath_matrix_get_transforms(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *mtx = dmScript::CheckMatrix4(L, 1);
    dmVMath::Vector3 *transform = dmScript::CheckVector3(L, 2);
    dmVMath::Vector3 *scale = dmScript::CheckVector3(L, 3);
    dmVMath::Quat *rotation = dmScript::CheckQuat(L, 4);

    dmTransform::Transform t1 = dmTransform::ToTransform(*mtx);

    *transform = t1.GetTranslation();
    *scale = t1.GetScale();
    *rotation = t1.GetRotation();

    return 0;
}

static int xMath_matrix_transform_set_scale(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *result = dmScript::CheckMatrix4(L, 1);
    dmVMath::Matrix4 mtx = *dmScript::CheckMatrix4(L, 2);
    dmVMath::Vector3 scale = *dmScript::CheckVector3(L, 3);

    dmTransform::Transform t1 = dmTransform::ToTransform(mtx);
    t1.SetScale(scale);
    *result = dmTransform::ToMatrix4(t1);

    return 0;
}

static int xMath_matrix_get_transforms_translate(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *mtx = dmScript::CheckMatrix4(L, 1);
    dmVMath::Vector3 *transform = dmScript::CheckVector3(L, 2);

    dmTransform::Transform t1 = dmTransform::ToTransform(*mtx);
    *transform = t1.GetTranslation();
    return 0;
}

static int xMath_matrix_from_transforms(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *mtx = dmScript::CheckMatrix4(L, 1);
    dmVMath::Vector3 *transform = dmScript::CheckVector3(L, 2);
    dmVMath::Vector3 *scale = dmScript::CheckVector3(L, 3);
    dmVMath::Quat *rotation = dmScript::CheckQuat(L, 4);

    dmTransform::Transform t1;
    t1.SetTranslation(*transform);
    t1.SetScale(*scale);
    t1.SetRotation(*rotation);

    *mtx = dmTransform::ToMatrix4(t1);

    return 0;
}

static int xMath_matrix_get_transforms_quat(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *mtx = dmScript::CheckMatrix4(L, 1);
    dmVMath::Quat *rotation = dmScript::CheckQuat(L, 2);

    dmTransform::Transform t1 = dmTransform::ToTransform(*mtx);
    *rotation = t1.GetRotation();

    return 0;
}

static int xMath_get_world_matrix(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmVMath::Matrix4 *out = dmScript::CheckMatrix4(L, 1);
    dmGameObject::HInstance rootInstance = dmScript::CheckGOInstance(L, 2);

    *out = GetWorldMatrix(rootInstance);

    return 0;
}

static int xMath_get_world_position(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);

    dmVMath::Vector3 *out = dmScript::CheckVector3(L, 1);
    dmGameObject::HInstance instance = dmScript::CheckGOInstance(L, 2);

    const dmVMath::Point3 &position = dmGameObject::GetWorldPosition(instance);
    out->setX(position.getX());
    out->setY(position.getY());
    out->setZ(position.getZ());

    return 0;
}

static int xMath_get_world_rotation(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);

    dmVMath::Quat *out = dmScript::CheckQuat(L, 1);
    dmGameObject::HInstance instance = dmScript::CheckGOInstance(L, 2);

    *out = dmGameObject::GetWorldRotation(instance);

    return 0;
}

static int xMath_calculate_direction_vectors(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);

    dmVMath::Vector3 *outX = dmScript::CheckVector3(L, 1);
    dmVMath::Vector3 *outY = dmScript::CheckVector3(L, 2);
    dmVMath::Vector3 *outZ = dmScript::CheckVector3(L, 3);
    dmVMath::Matrix4 *m = dmScript::CheckMatrix4(L, 4);

    // Perform matrix-vector multiplication similar to the Lua version
    dmVMath::Vector4 p0 = *m * dmVMath::Vector4(0, 0, 0, 1);
    dmVMath::Vector4 p1 = *m * dmVMath::Vector4(1, 0, 0, 1);
    dmVMath::Vector4 p2 = *m * dmVMath::Vector4(0, 1, 0, 1);
    dmVMath::Vector4 p3 = *m * dmVMath::Vector4(0, 0, -1, 1);

    // Normalize the points
    p0 = p0 / p0.getW();
    p1 = (p1 / p1.getW()) - p0;
    p2 = (p2 / p2.getW()) - p0;
    p3 = (p3 / p3.getW()) - p0;

    // Update the output vectors
    *outX = Vectormath::Aos::normalize(dmVMath::Vector3(p1.getX(), p1.getY(), p1.getZ()));
    *outY = Vectormath::Aos::normalize(dmVMath::Vector3(p2.getX(), p2.getY(), p2.getZ()));
    *outZ = Vectormath::Aos::normalize(dmVMath::Vector3(p3.getX(), p3.getY(), p3.getZ()));

    return 0;
}

static int xMath_is_vector3(lua_State *L) {
    lua_pushboolean(L, dmScript::IsVector3(L, 1));
    return 1;
}

static int xMath_is_vector4(lua_State *L) {
    lua_pushboolean(L, dmScript::IsVector4(L, 1));
    return 1;
}

static int xMath_is_quat(lua_State *L) {
    lua_pushboolean(L, dmScript::IsQuat(L, 1));
    return 1;
}

//* Native Extension Bindings
//* ----------------------------------------------------------------------------

static const luaL_reg xMathModule_methods[] =
    {
        //* Arithmetic
        {"add", xMath_add},
        {"sub", xMath_sub},
        {"mul", xMath_mul},
        {"div", xMath_div},
        //* Vector
        {"cross", xMath_cross},
        {"mul_per_elem", xMath_mul_per_elem},
        {"normalize", xMath_normalize},
        {"rotate", xMath_rotate},
        {"vector", xMath_vector},
        {"vector3_set_components", xMath_vector3_set_components},
        {"vector4_set_components", xMath_vector4_set_components},
        //* Quat
        {"conj", xMath_conj},
        {"quat_axis_angle", xMath_quat_axis_angle},
        {"quat_basis", xMath_quat_basis},
        {"quat_from_to", xMath_quat_from_to},
        {"quat_rotation_x", xMath_quat_rotation_x},
        {"quat_rotation_y", xMath_quat_rotation_y},
        {"quat_rotation_z", xMath_quat_rotation_z},
        {"quat_mul", xMath_quat_mul},
        {"quat", xMath_quat},
        {"quat_reverse", xMath_quat_reverse},
        //* Vector + Quat
        {"lerp", xMath_lerp},
        {"slerp", xMath_slerp},
        //* Matrix
        {"matrix", xMath_matrix},
        {"matrix_axis_angle", xMath_matrix_axis_angle},
        {"matrix_from_quat", xMath_matrix_from_quat},
        {"matrix_frustum", xMath_matrix_frustum},
        {"matrix_inv", xMath_matrix_inv},
        {"matrix_from_matrix", xMath_matrix_from_matrix},
        {"matrix_look_at", xMath_matrix_look_at},
        {"matrix4_orthographic", xMath_matrix_orthographic},
        {"matrix_ortho_inv", xMath_matrix_ortho_inv},
        {"matrix4_perspective", xMath_matrix_perspective},
        {"matrix_rotation_x", xMath_matrix_rotation_x},
        {"matrix_rotation_y", xMath_matrix_rotation_y},
        {"matrix_rotation_z", xMath_matrix_rotation_z},
        {"matrix_translation", xMath_matrix_translation},
        {"matrix_mul", xMath_matrix_mul},
        {"matrix_mul_v4", xMath_matrix_mul_v4},
        {"matrix_transpose", xMath_matrix_transpose},
        {"matrix_get_transforms", xMath_matrix_get_transforms},
        {"matrix_get_transforms_quat", xMath_matrix_get_transforms_quat},
        {"matrix_get_transforms_translate", xMath_matrix_get_transforms_translate},
        {"matrix_from_transforms", xMath_matrix_from_transforms},
        {"matrix_transform_set_scale", xMath_matrix_transform_set_scale},
        {"quat_to_euler", xMath_quat_to_euler},
        {"euler_to_quat", xMath_euler_to_quat},
        {"go_get_world_matrix", xMath_get_world_matrix},
        {"go_get_world_position", xMath_get_world_position},
        {"go_get_world_rotation", xMath_get_world_rotation},
        {"calculate_direction_vectors", xMath_calculate_direction_vectors},
        {"is_vector3", xMath_is_vector3},
        {"is_vector4", xMath_is_vector4},
        {"is_quat", xMath_is_quat},
        {0, 0}};

static void xMathLuaInit(lua_State *L) {
    int top = lua_gettop(L);

    luaL_register(L, MODULE_NAME, xMathModule_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result xMathInitialize(dmExtension::Params *params) {
    xMathLuaInit(params->m_L);
    dmLogInfo("Registered %s Extension", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

// Defold SDK uses a macro for setting up extension entry points:
// It must match the name field in the `ext.manifest`
DM_DECLARE_EXTENSION(xMath, LIB_NAME, 0, 0, xMathInitialize, 0, 0, 0)
