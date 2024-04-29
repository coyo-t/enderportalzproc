#pragma once

#include"GML.hpp"
#include"pch.h"
#include"scr_end_portal_state.hpp"
#include<stdio.h>


static EndPortalState* state;

// This Is Stupid.
#ifdef __cplusplus
extern "C" {
#endif

GMLEXPORT double create (double wide, double tall)
{
	state = new EndPortalState((int)wide, (int)tall);
	state->create_kernel_table();
	return 0;
}

GMLEXPORT double destroy ()
{
	delete state;
	return 0;
}

GMLEXPORT double tick (double time)
{
	state->tick(time);
	return 0;
}

GMLEXPORT double get_buffer (void* buffer)
{
	auto* into = (float*)buffer;
	auto* src = state->get_buffer();

	for (int i = state->get_count(); (--i) >= 0;)
	{
		into[i] = (float)src[i];
	}

	return 0;
}

GMLEXPORT double get_count ()
{
	return state->get_count();
}

GMLEXPORT double get_buffer_size ()
{
	return state->get_buffer_size();
}

GMLEXPORT double clear_buffers ()
{
	state->clear_buffers();
	return 0;
}

#ifdef __cplusplus
}
#endif
