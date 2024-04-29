#pragma once

#include"scr_random.hpp"
#include"math.h"
#include"GML.hpp"
#include<algorithm>
#include<stdio.h>
#include<format>
#include"scr_swappy.hpp"

// This Is Stupid.
static int wrapp (int _v, int _s)
{
	if (_v >= _s)
	{
		while (_v >= _s) _v -= _s;
		_v = (_s-1) - _v;
	}

	if (_v < 0)
	{
		while (_v < 0) _v += _s;
		_v = (_s-1) - _v;
	}
	return _v;
}

using Numberz = double;

static struct KernelEntry
{
	int x=0, y=0;
	Numberz dist=1.0;

	void set (int x, int y, Numberz dist)
	{
		this->x = x;
		this->y = y;
		this->dist = dist;
	}

};

static struct DropletShit
{
	int time = 0;
	int summon_count = 0;
	int summon_current = 0;
	Numberz summon_rcp = 1.0;
	int next_time = 0;
};

static struct KernelTable
{
	Numberz total = 0.0;
	int count = 0;
	KernelEntry* lut = nullptr;

	void destroy ()
	{
		if (lut != nullptr)
		{
			delete[] lut;
		}
		lut = nullptr;
		count = 0;
		total = 0.0;
	}

	~KernelTable ()
	{
		destroy();
	}
};

struct EndPortalState
{
	Random r = Random(0L);

	int wide, tall, count;

	SwapperBuffer<Numberz> data;

	DropletShit droplet;
	KernelTable kernel;

	void update_next_droplet ()
	{
		droplet.next_time = r.next_int(10, 40);
	}

	EndPortalState (int wide, int tall)
	{
		this->wide = wide;
		this->tall = tall;
		count = wide*tall;
		data.create(count);
		
		clear_buffers();
	}

	void destroy ()
	{
		data.destroy();
		kernel.destroy();
	}

	~EndPortalState ()
	{
		destroy();
	}

	auto* get_buffer () const
	{
		return data.current;
	}

	void* get_buffer_ptr () const
	{
		return (void*)get_buffer();
	}

	int get_count () const
	{
		return data.size();
	}

	int get_buffer_size () const
	{
		return data.size_bytes();
	}

	int xytoi (int x, int y) const
	{
		return y*wide+x;
	}

	int xytoi (Numberz x, Numberz y) const
	{
		return xytoi((int)x, (int)y);
	}

	int xytoi_wrap (Numberz _x, Numberz _y) const
	{
		return xytoi_wrap((int)_x, (int)_y);
	}

	int xytoi_wrap (int _x, int _y) const
	{
		return xytoi(wrapp(_x, wide), wrapp(_y, tall));
	}

	void tick (double time)
	{
		data.swap();

		if ((droplet.time++) >= droplet.next_time and droplet.summon_count <= 0)
		{
			droplet.summon_count = droplet.summon_current = r.next_int(1, 12);
			droplet.summon_rcp = 1.0 / droplet.summon_count;
			update_next_droplet();
			droplet.time = 0;
		}
		
		auto* const prev = data.previous;
		auto* const current = data.current;
		if (droplet.summon_current > 0)
		{
			for (int REPEATER = r.next_int(1, 2); (REPEATER--)>=0;)
			{
				auto modd = droplet.summon_current * droplet.summon_rcp;
				droplet.summon_count--;
				if ((--droplet.summon_count)<= 0)
				{
					break;
				}
				auto mx = r.next_int(wide-1);
				auto my = r.next_int(tall-1);

				if (r.next_int(10) <= 5)
				{
					auto str = (r.next_int(1) * 2 - 1) * r.next_double(0.4, 0.7) * modd;
					prev[xytoi_wrap(mx, my)] += str;
					str *= 0.5;
					prev[xytoi_wrap(mx+1, my)] += str;
					prev[xytoi_wrap(mx-1, my)] += str;
					prev[xytoi_wrap(mx, my-1)] += str;
					prev[xytoi_wrap(mx, my+1)] += str;
				}
				else
				{
					auto str = (r.next_int(1) * 2 - 1) * r.next_double(0.8, 1.1) * modd;
					auto dist = r.next_int(8) >> 1;
					// lazy
					if (r.next_int(1) == 0)
					{
						for (int i = -dist; i <= dist; i++)
						{
							prev[xytoi_wrap(mx+i, my)] += str;
						}
					}
					else
					{
						for (int i = -dist; i <= dist; i++)
						{
							prev[xytoi_wrap(mx, my+i)] += str;
						}
					}
				}
			}
		}

		// begin
		{
			// very lazy
			auto spinnerpow = 0.35 + r.next_double_sym(+0.1);
			auto tsin = sin(time);
			auto tcos = cos(time);
			auto maxi = 1.0 / sqrt(max(abs(tsin), abs(tcos)));
			tsin = floor((tsin * maxi * 0.5 + 0.5) * wide);
			tcos = floor((tcos * maxi * 0.5 + 0.5) * tall);
			prev[xytoi(tsin, tcos)] -= spinnerpow;
			prev[xytoi(wide-tsin-1.0, tall-tcos-1.0)] += spinnerpow;
		}
		
		// address maths can be crushed down further.
		// im tired though. hhh.
		auto total = kernel.total;
		auto kernel_lut = kernel.lut;
		for (int yy = 0; yy < tall; yy++)
		{
			for (int xx = 0; xx < wide; xx++)
			{
				auto ii = xytoi(xx, yy);
				auto cur = current[ii];
				Numberz sum = 0;

				for (int i = kernel.count; (--i) >= 0; )
				{
					auto kt = kernel_lut[i];
					auto jj = xytoi_wrap(xx+kt.x, yy+kt.y);
					sum += prev[jj] * kt.dist;
				}

				cur = sum * total - cur;
				cur -= cur * r.next_double(0.005, 0.2);
				current[ii] = cur + r.next_double_sym(0.01);
			}
		}
	}

	void clear_buffers ()
	{
		data.fill_both(0);
	}

	void create_kernel_table ()
	{
		const int sz = 1;
		const int count = (sz*2+1)*(sz*2+1);
		kernel.count = count;
		kernel.lut = new KernelEntry[count];

		Numberz total = 0;
		int i = 0;
		for (int ky = -sz; ky<=+sz; ky++)
		{
			for (int kx = -sz; kx<=+sz; kx++)
			{
				auto* kk = &kernel.lut[i++];
				if (kx == 0 and ky == 0)
				{
					kk->set(0, 0, 1.0);
					continue;
				}
				auto dist = sqrt(kx*kx + ky*ky);
				kk->set(kx, ky, 1.0 / dist);
				total += dist;
			}
		}
		kernel.total = 1.0 / (total * 0.5);
	}
};
