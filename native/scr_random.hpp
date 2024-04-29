#pragma once

using ULong = unsigned long long;
using UInt  = unsigned int;

// This Is Stupid
static const ULong ANDZOR = 0xffffffffffffUL;// (1UL << 48UL) - 1UL;
//static const double DOUBLEDIVZOR = (double)0x1fffffffffffffUL; // (1UL << 53) - 1
//static const float FLOATDIVZOR = (float)0xffffff; // (1 << 24)-1
static const double DOUBLEDIVZOR = (double)0x20000000000000UL; // (1UL << 53)
static const float FLOATDIVZOR = (float)0x1000000; // (1 << 24)

class Random
{
	ULong seed;

	UInt next (UInt bits)
	{
		seed = (seed * 0x5DEECE66DUL + 0xBL) & ANDZOR;
		return (UInt)(seed >> (48 - bits));
	}

	public:
	Random (ULong seed)
	{
		set_seed(seed);
	}

	void set_seed (ULong newSeed)
	{
		seed = (newSeed ^ 0x5DEECE66DUL) & ANDZOR;
	}

	double next_double ()
	{
		return (((ULong)next(26) << 27) + next(27)) / DOUBLEDIVZOR;
	}

	double next_double (double upper)
	{
		return next_double() * upper;
	}

	double next_double (double lower, double upper)
	{
		return next_double() * (upper - lower) + lower;
	}

	double next_double_sym ()
	{
		return next_double() * 2 - 1;
	}

	double next_double_sym (double radius)
	{
		return next_double(-radius, +radius);
	}

	double next_double_sym (double radius, double pivot)
	{
		return pivot + next_double_sym(radius);
	}

	float next_float ()
	{
		return next(24) / FLOATDIVZOR;
	}

	float next_float (float upper)
	{
		return next_float() * upper;
	}

	float next_float (float lower, float upper)
	{
		return next_float() * (upper - lower) + lower;
	}

	float next_float_sym (float radius)
	{
		return next_float(-radius, +radius);
	}

	float next_float_sym (float radius, float pivot)
	{
		return pivot + next_float_sym(radius);
	}

	int next_int ()
	{
		auto outs = next(32);
		return *(int*)(&outs);
	}

	// this is silly but i dont feel like completely dealing with
	// inclusive vs exclusive upper bound shit from java to gml -_-
	int next_int (int upper)
	{
		return (int)next_float(upper+1);
	}

	int next_int (int lower, int upper)
	{
		return (int)next_float(lower, upper+1);
	}


};
