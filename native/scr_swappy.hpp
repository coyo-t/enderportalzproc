#pragma once

template<typename T>
class SwapperBuffer
{
	int count;
	
	public:
	T* current;
	T* previous;

	SwapperBuffer ()
	{
		count = 0;
		current = nullptr;
		previous = nullptr;
	}

	void create (int count)
	{
		destroy();
		this->count = count;
		current = new T[count];
		previous = new T[count];
	}

	SwapperBuffer (int count)
	{
		create(count);
	}

	void destroy ()
	{
		if (current != nullptr)
		{
			delete[] current;
			current = nullptr;
		}

		if (previous != nullptr)
		{
			delete[] previous;
			previous = nullptr;
		}
		count = 0;
	}

	~SwapperBuffer ()
	{
		destroy();
	}

	void fill_both (T with)
	{
		for (int i = count; (--i) >= 0;)
		{
			current[i] = with;
			previous[i] = with;
		}
	}

	void swap ()
	{
		auto* temp = current;
		current = previous;
		previous = temp;
	}

	int size () const
	{
		return count;
	}

	int size_bytes () const
	{
		return size() * sizeof(T);
	}

	int sizeof_element () const
	{
		return sizeof(T);
	}
};
