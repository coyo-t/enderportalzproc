#ifndef GML
#define GML

#include"Extension_Interface.h"

#ifdef _MSC_VER
#define GMLEXPORT extern __declspec(dllexport)
#else
#define GMLEXPORT extern
#endif

//#define GMFUNC(name) __declspec(dllexport) void name(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)

YYRunnerInterface gs_runnerInterface;
YYRunnerInterface* g_pYYRunnerInterface;

GMLEXPORT void YYExtensionInitialise(const struct YYRunnerInterface* _pFunctions, size_t _functions_size)
{
	if (_functions_size < sizeof(YYRunnerInterface))
	{
		memcpy(&gs_runnerInterface, _pFunctions, _functions_size);
	}
	else
	{
		memcpy(&gs_runnerInterface, _pFunctions, sizeof(YYRunnerInterface));
	}
	g_pYYRunnerInterface = &gs_runnerInterface;
	DebugConsoleOutput("Successfully initialized runner interface");
	//WriteLog("Successfully initialized runner interface");
	return;
}

#endif // !GML

