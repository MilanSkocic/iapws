#include "_core.h"

Py_buffer newbuffer_like(Py_buffer *buffer){
    Py_buffer newbuffer;
    newbuffer.buf = PyMem_Malloc(buffer->len);
    newbuffer.obj = NULL;
    newbuffer.len = buffer->len;
    newbuffer.readonly = buffer->readonly;
    newbuffer.itemsize = buffer->itemsize;
    newbuffer.format = buffer->format;
    newbuffer.ndim = buffer->ndim;
    newbuffer.shape = buffer->shape;
    newbuffer.strides = buffer->strides;
    newbuffer.suboffsets = NULL;

    return newbuffer;
}
