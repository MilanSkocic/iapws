#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>
#include <string.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the Fortran iapws library.");

PyDoc_STRVAR(iapws_kh_doc, 
"get_kh(T, gas, solvent) --> float \n\n"
"Get the kH value for gas in solvent for T. If not found returns NaN");

PyDoc_STRVAR(iapws_kd_doc, 
"get_kd(T, gas, solvent) --> float \n\n"
"Get the kD value for gas in solvent for T. If not found returns NaN");

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

static PyObject *iapws_kh(PyObject *self, PyObject *args){

    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    char *gas;
    char *solvent;
    double value, T;

    Py_ssize_t i;

    if(!PyArg_ParseTuple(args, "Oss", &T_obj, &gas, &solvent)){
        PyErr_SetString(PyExc_TypeError, "T is float, gas and solvent are strings.");
        return NULL;
    }

    if(PyFloat_Check(T_obj) == 1){
        value = iapws_capi_kh(PyFloat_AsDouble(T_obj), gas, solvent, strlen(gas), strlen(solvent));
        return Py_BuildValue("d", value);
    }else if(PyLong_Check(T_obj)==1){
        value = iapws_capi_kh(PyLong_AsDouble(T_obj), gas, solvent, strlen(gas), strlen(solvent));
        return Py_BuildValue("d", value);
    }else if(PyObject_CheckBuffer(T_obj)==1){
        mview = PyMemoryView_FromObject(T_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, "T must be a 1d-array of floats.");
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, "T must be a 1d-array of floats.");
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            for(i=0; i<buffer->shape[0]; i++){
                T =  *(((double * )buffer->buf)+i);
                value = iapws_capi_kh(T, gas, solvent, strlen(gas), strlen(solvent));
                *(((double *) newbuffer.buf)+i) = value;
            }
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, "T must be an int, a float or a 1d-array of floats");
        return NULL;
    }

}


static PyObject *iapws_kd(PyObject *self, PyObject *args){

    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    char *gas;
    char *solvent;
    double value, T;

    Py_ssize_t i;

    if(!PyArg_ParseTuple(args, "Oss", &T_obj, &gas, &solvent)){
        PyErr_SetString(PyExc_TypeError, "T is float, gas and solvent are strings.");
        return NULL;
    }

    if(PyFloat_Check(T_obj) == 1){
        value = iapws_capi_kd(PyFloat_AsDouble(T_obj), gas, solvent, strlen(gas), strlen(solvent));
        return Py_BuildValue("d", value);
    }else if(PyLong_Check(T_obj)==1){
        value = iapws_capi_kd(PyLong_AsDouble(T_obj), gas, solvent, strlen(gas), strlen(solvent));
        return Py_BuildValue("d", value);
    }else if(PyObject_CheckBuffer(T_obj)==1){
        mview = PyMemoryView_FromObject(T_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, "T must be a 1d-array of floats.");
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, "T must be a 1d-array of floats.");
            return NULL;
        }else{
            newbuffer = newbuffer_like(buffer);
            for(i=0; i<buffer->shape[0]; i++){
                T =  *(((double * )buffer->buf)+i);
                value = iapws_capi_kd(T, gas, solvent, strlen(gas), strlen(solvent));
                *(((double *) newbuffer.buf)+i) = value;
            }
            new_mview = PyMemoryView_FromBuffer(&newbuffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, "T must be an int, a float or a 1d-array of floats");
        return NULL;
    }

}

static PyMethodDef myMethods[] = {
    {"kh", (PyCFunction) iapws_kh, METH_VARARGS, iapws_kh_doc},
    {"kd", (PyCFunction) iapws_kd, METH_VARARGS, iapws_kd_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef iapws = {
    PyModuleDef_HEAD_INIT,
    "iapws",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_iapws(void)
{
    return PyModule_Create(&iapws);
}


