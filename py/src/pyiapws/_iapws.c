#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws modules of the Fortran iapws library.");

/* R797 Doc */
PyDoc_STRVAR(r797_psat_doc, 
"psat(Ts: array-like) --> mview \n\n"
"Get the saturation-pressure line. If gas not found returns NaNs");
PyDoc_STRVAR(r797_Tsat_doc, 
"Tsat(ps: array-like) --> mview \n\n"
"Get the saturation-temperature line. If gas not found returns NaNs");

/* G704 Doc */
PyDoc_STRVAR(g704_kh_doc, 
"kh(T: array-like, gas: str, heavywater :bool) --> mview \n\n"
"Get the Henry constant for gas in H2O or D2O for T. If gas not found returns NaNs");
PyDoc_STRVAR(g704_kd_doc, 
"kd(T: array-like, gas, heavywater: bool) --> mview \n\n"
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


/*Common function*/
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


/* R797 */
static PyObject *r797_psat(PyObject *self, PyObject *args){
    
    PyObject *T_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &T_obj)){
        return NULL;
    }

    mview = PyMemoryView_FromObject(T_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
    newbuffer = newbuffer_like(buffer);
    iapws_r797_psat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);

    return new_mview;
}

static PyObject *r797_Tsat(PyObject *self, PyObject *args){
    PyObject *p_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "O", &p_obj)){
        return NULL;
    }

    mview = PyMemoryView_FromObject(p_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
    newbuffer = newbuffer_like(buffer);
    iapws_r797_Tsat(buffer->shape[0], (double *) buffer->buf, (double *) newbuffer.buf);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);

    return new_mview;
}


/* G704 */
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
            fkx = &iapws_g704_kh;
            break;
        case 'd':
            fkx = &iapws_g704_kd;
            break;
        default:
            fkx = NULL;
    }
    
    if(!PyArg_ParseTuple(args, "Osp", &T_obj, &gas, &heavywater)){
        return NULL;
    }

    mview = PyMemoryView_FromObject(T_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
    newbuffer = newbuffer_like(buffer);
    fkx((double *)buffer->buf, gas, heavywater, (double *)newbuffer.buf, strlen(gas), newbuffer.shape[0]);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);
    return new_mview;
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
        return NULL;
    }
    ngas = iapws_g704_ngases(heavywater);
    
    return Py_BuildValue("i", ngas);
}

static PyObject *g704_gases(PyObject *self, PyObject *args){
    
    int heavywater;
    char **gases;
    int ngas;
    Py_ssize_t i;
    PyObject *tuple;

    if(!PyArg_ParseTuple(args, "p", &heavywater)){
        return NULL;
    }
    ngas = iapws_g704_ngases(heavywater);
    gases = iapws_g704_gases(heavywater);
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
        return NULL;
    }
    gases = iapws_g704_gases2(heavywater);
    py_gases = PyUnicode_FromFormat("%s", gases);
    return py_gases;
}



static PyMethodDef myMethods[] = {
    {"psat", (PyCFunction) r797_psat, METH_VARARGS, r797_psat_doc},
    {"Tsat", (PyCFunction) r797_Tsat, METH_VARARGS, r797_Tsat_doc},
    {"kh", (PyCFunction) g704_kh, METH_VARARGS, g704_kh_doc},
    {"kd", (PyCFunction) g704_kd, METH_VARARGS, g704_kd_doc},
    {"ngases", (PyCFunction) g704_ngases, METH_VARARGS, g704_ngases_doc},
    {"gases", (PyCFunction) g704_gases, METH_VARARGS, g704_gases_doc},
    {"gases2", (PyCFunction) g704_gases2, METH_VARARGS, g704_gases2_doc},
    { NULL, NULL, 0, NULL }
};
static struct PyModuleDef _iapws = {PyModuleDef_HEAD_INIT, "_iapws", module_docstring, -1, myMethods};

PyMODINIT_FUNC PyInit__iapws(void){
    PyObject *m;
    PyObject *d;
    PyObject *v;
    m = PyModule_Create(&_iapws);
    d = PyModule_GetDict(m);
    
    v = PyUnicode_FromFormat("%s", iapws_get_version());
    PyDict_SetItemString(d, "__version__", v);
    Py_INCREF(v);

    v = PyFloat_FromDouble(iapws_r283_Tc_H2O);
    PyDict_SetItemString(d, "Tc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_Tc_D2O);
    PyDict_SetItemString(d, "Tc_D2O", v);
    Py_INCREF(v);
    
    v = PyFloat_FromDouble(iapws_r283_pc_H2O);
    PyDict_SetItemString(d, "pc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_pc_D2O);
    PyDict_SetItemString(d, "pc_D2O", v);
    Py_INCREF(v);
    
    v = PyFloat_FromDouble(iapws_r283_rhoc_H2O);
    PyDict_SetItemString(d, "rhoc_H2O", v);
    Py_INCREF(v);
    v = PyFloat_FromDouble(iapws_r283_rhoc_D2O);
    PyDict_SetItemString(d, "rhoc_D2O", v);
    Py_INCREF(v);
    
    return m;
}