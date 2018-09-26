
// AgoraSignalingutorial.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"


// CAgoraSignalingutorialApp: 
// AgoraSignalingutorial.cpp
//

class CAgoraSignalingutorialApp : public CWinApp
{
public:
	CAgoraSignalingutorialApp();

// override
public:
	virtual BOOL InitInstance();

// Implement

	DECLARE_MESSAGE_MAP()
};

extern CAgoraSignalingutorialApp theApp;