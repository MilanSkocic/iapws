#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <string.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws_g704 module of the Fortran iapws library.");

PyDoc_STRVAR(g704_kh_doc, 
"kh(T: array, gas: str, heavywater :bool) --> mview \n\n"
"Get the Henry constant for gas in H2O or D2O for T. If gas not found returns NaNs");

PyDoc_STRVAR(g704_kd_doc, 
"kd(T: array, gas, heavywater: bool) --> mview \n\n"
"Get the vapor-liquid constant for gas in H2O or D2O for T. If gas not found returns NaNs");

PyDoc_STRVAR(g704_ngases_doc,
"gases(heavywater: bool) --> int\n\n"
"Get the number of available gases.");

PyDoc_STRVAR(g704_gases_doc,
"gases(heavywater: bool) --> tuple\n\n"
"Get the available gases.");

PyDoc_STRVAR(g704_gases2_doc,
"gases(heavywater: bool) --> str\n\n"
"Get the available gases as a string.");

static const char ERR_MSG_PARSING[] = "T is an object with the buffer protocol, gas is a string, heavywater is a boolean.";
static const char ERR_MSG_T_DIM[] = "T must be a 1d-array of floats.";
static const char ERR_MSG_T_TYPE[] = "T must be a 1d-array of floats.";

static Py_buffer newbuffer_like(Py_buffer *buffer){
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

static PyObject *kx(char k, PyObject *args){
    
    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    char *gas;
    int heavywater;

    void (*fkx)(double *, char *, int, double *, int, size_t);

    switch(k){
        case 'h':
            fkx = &iapws_g704_capi_kh;
            break;
        case 'd':
            fkx = &iapws_g704_capi_kd;
            break;
        default:
            fkx = NULL;
    }
    
    if(!PyArg_ParseTuple(args, "Osp", &T_obj, &gas, &heavywater)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }

    if(PyObject_CheckBuffer(T_obj)==1){
        mview = PyMemoryView_FromObject(T_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_TYPE);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_T_DIM);
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            fkx((double *)buffer->buf, gas, heavywater, (double *)newbuffer.buf, strlen(gas), newbuffer.shape[0]);
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_PARSING);
        return NULL;
    }
}

static PyObject *g704_kh(PyObject *self, PyObject *args){
    return kx('h', args);
}

static PyObject *g704_kd(PyObject *self, PyObject *args){
    return kx('d', args);
}

static PyObject *g704_ngases(PyObject *self, PyObject *args){
    int heavywater;
    int ngas;
    
    if(!PyArg_ParseTuple(args, "p", &heavywater)){
        PyErr_SetString(PyExc_TypeError, "heavywater is a boolean.");
        return NULL;
    }
    ngas = iapws_g704_capi_ngases(heavywater);
    
    return Py_BuildValue("i", ngas);
}

static PyObject *g704_gases(PyObject *self, PyObject *args){
    
    int heavywater;
    char **gases;
    int ngas;
    Py_ssize_t i;
    PyObject *tuple;

    if(!PyArg_ParseTuple(args, "p", &heavywater)){
        PyErr_SetString(PyExc_TypeError, "heavywater is a boolean.");
        return NULL;
    }
    ngas = iapws_g704_capi_ngases(heavywater);
    gases = iapws_g704_capi_gases(heavywater);
    tuple = PyTuple_New((Py_ssize_t) ngas);
    for(i=0; i<ngas; i++){
        PyTuple_SET_ITEM(tuple, i, PyUnicode_FromFormat("%s", gases[i]));
    }
    return tuple;
}

static PyObject *g704_gases2(PyObject *self, PyObject *args){
    
    int heavywater;
    char *gases;
    PyObject *py_gases;

    if(!PyArg_ParseTuple(args, "p", &heavywater)){
        PyErr_SetString(PyExc_TypeError, "heavywater is a boolean.");
        return NULL;
    }
    gases = iapws_g704_capi_gases2(heavywater);
    py_gases = PyUnicode_FromFormat("%s", gases);
    return py_gases;
}

static PyMethodDef myMethods[] = {
    {"kh", (PyCFunction) g704_kh, METH_VARARGS, g704_kh_doc},
    {"kd", (PyCFunction) g704_kd, METH_VARARGS, g704_kd_doc},
    {"ngases", (PyCFunction) g704_ngases, METH_VARARGS, g704_ngases_doc},
    {"gases", (PyCFunction) g704_gases, METH_VARARGS, g704_gases_doc},
    {"gases2", (PyCFunction) g704_gases2, METH_VARARGS, g704_gases2_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef g704 = {
    PyModuleDef_HEAD_INIT,
    "g704",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_g704(void)
{
    return PyModule_Create(&g704);
}


