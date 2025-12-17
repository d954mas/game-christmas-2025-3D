#ifndef native_camera_h
#define native_camera_h

#include <dmsdk/sdk.h>
#include <cstdio> // For snprintf

namespace NativeCamera {

enum CameraOrthoScaleMode {
	EXPANDVIEW,
	FIXEDAREA,
	FIXEDWIDTH,
	FIXEDHEIGHT
};

class Camera {
	public:
	explicit Camera();
	~Camera();

	bool orthographic;
	float orthoScale;
	CameraOrthoScaleMode orthoScaleMode;
	float viewAreaWidth;
	float viewAreaHeight;

	float screenWidth;
	float screenHeight;
	float screenAspectRatio;

	dmVMath::Vector3 pos;
	dmVMath::Quat rot;

	float fov;
	float nearZ;
	float farZ;

	dmVMath::Matrix4 view;
	dmVMath::Matrix4 proj;

	bool dirtyView;
	bool dirtyProj;

	void setPosition(dmVMath::Vector3 pos);
	void setRotation(dmVMath::Quat rot);

	void setOrthographic(bool orthographic);
	void setOrthoScale(float orthoScale);
	void setOrthoScaleMode(CameraOrthoScaleMode scaleMode);
	void setViewArea(float viewAreaWidth, float viewAreaHeight);
	void setScreenSize(float screenWidth, float screenHeight);
	void setFov(float fov);
	void setNearZ(float nearZ);
	void setFarZ(float farZ);

	dmVMath::Matrix4 getView();
	dmVMath::Matrix4 getProj();
	dmVMath::Matrix4 getFrustum();
	void worldToScreen(dmVMath::Vector3 worldPos, float *outX, float *outY);
	void screenToWorld2D(float screenX, float screenY, float *outX, float *outY);
	void screenToWorldRay(float screenX, float screenY, dmVMath::Vector3 *start, dmVMath::Vector3 *end);
	bool screenToWorldPlane(float screenX, float screenY, dmVMath::Vector3 planeNormal, dmVMath::Vector3 pointOnPlane, dmVMath::Vector3 *out);
	void toString(char* buffer, size_t size);
};

}

#endif