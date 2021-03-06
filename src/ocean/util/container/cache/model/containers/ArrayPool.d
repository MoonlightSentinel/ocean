/*******************************************************************************

    Basic preallocated pool of a fixed number of value type items, all items are
    stored in one dynamic array.
    Uses malloc() instead of D memory managed allocation for two reasons:
      1. The exact size is specified at instantiation so allocating extra space
         as the D memory manager does is not desired.
      2. The elements do not contain references to D memory managed objects so
         they can be invisible to the GC.

    Copyright:
        Copyright (c) 2009-2016 dunnhumby Germany GmbH.
        All rights reserved.

    License:
        Boost Software License Version 1.0. See LICENSE_BOOST.txt for details.
        Alternatively, this file may be distributed under the terms of the Tango
        3-Clause BSD License (see LICENSE_BSD.txt for details).

*******************************************************************************/

module ocean.util.container.cache.model.containers.ArrayPool;


import core.stdc.stdlib: malloc, free;

import ocean.core.ExceptionDefinitions: onOutOfMemoryError;

/******************************************************************************/

class ArrayPool ( T ) : GenericArrayPool
{
    /***************************************************************************

        Constructor.

        Params:
            n = maximum number of elements that can be obtained

    ***************************************************************************/

    public this ( size_t n )
    {
        super(n, T.sizeof);
    }

    /***************************************************************************

        Obtains the next element in the pool.

        It is an error to obtain more elements than the value n passed to the
        constructor. In this case an array out of bounds error is raised.

        Returns:
            the next pool element.

    ****************************************************************************/

    public override T* next ( )
    {
        return cast(T*)super.next;
    }
}

/******************************************************************************/

class GenericArrayPool
{
    import ocean.core.Verify;

    /***************************************************************************

        Byte length of each element.

    ***************************************************************************/

    public size_t element_size;

    /***************************************************************************

        Element data.

    ***************************************************************************/

    private void[] elements;

    /***********************************************************************

        Number of elements obtained since instantiation or the last clear()
        call.

    ***********************************************************************/

    private size_t n_created = 0;

    /***********************************************************************

        Constructor.

        Params:
            n = maximum number of elements in mapping
            element_size = size of a single element

    ***********************************************************************/

    public this ( size_t n, size_t element_size )
    {
        verify(element_size > 0, "zero element size specified");

        n *= (this.element_size = element_size);

        auto elements_buf = malloc(n);

        if (elements_buf)
        {
            this.elements = elements_buf[0 .. n];
        }
        else
        {
            onOutOfMemoryError();
            this.elements = null;
        }
    }

    /***************************************************************************

        Destructor.

    ***************************************************************************/

    ~this ( )
    {
        if (this.elements.ptr)
        {
            free(this.elements.ptr);
        }
    }

    /***************************************************************************

        Obtains the next element in the pool.

        It is an error to obtain more elements than the value n passed to the
        constructor. In this case an array out of bounds error is raised.

        Returns:
            a pointer to the next pool element.

    ****************************************************************************/

    public void* next ( )
    {
        return &this.elements[this.n_created++ * this.element_size];
    }

    /***************************************************************************

        Marks all elements in the pool as free.

    ****************************************************************************/

    public void clear ( )
    {
        this.n_created = 0;
    }
}
