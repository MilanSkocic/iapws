#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "iapws.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the iapws modules of the Fortran iapws library.");

/* R797 Doc */
PyDoc_STRVAR(r797_psat_doc, 
"psat(Ts: array-like) --> mview \n\n"
"Get the saturation-pressure line.");
PyDoc_STRVAR(r797_Tsat_doc, 
"Tsat(ps: array-like) --> mview \n\n"
"Get the saturation-temperature line.");
PyDoc_STRVAR(r797_wp_doc, 
"wp(p: array-like, T: array-like, prop: str) --> mview \n\n"
"Get water property.");
PyDoc_STRVAR(r797_wr_doc, 
"wr(p: array-like, T: array-like) --> mview \n\n"
"Get water region.");
PyDoc_STRVAR(r797_wph_doc, 
"wph(p: array-like, T: array-like) --> mview \n\n"
"Get water phase.");


/* G704 Doc */
PyDoc_STRVAR(g704_kh_doc, 
"kh(T: array-like, gas: str, heavywater :bool) --> mview \n\n"
"Get the Henry constant for gas in H2O or D2O for T.");
PyDoc_STRVAR(g704_kd_doc, 
"kd(T: array-like, gas, heavywater: bool) --> mview \n\n"
"Get the vapor-liquid constant for gas in H2O or D2O for T.");
PyDoc_STRVAR(g704_ngases_doc,
"gases(heavywater: bool) --> int\n\n"
"Get the number of available gases.");
PyDoc_STRVAR(g704_gases_doc,
"gases(heavywater: bool) --> tuple\n\n"
"Get the available gases.");
PyDoc_STRVAR(g704_gases2_doc,
"gases(heavywater: bool) --> str\n\n"
"Get the available gases as a string.");

/* R1124 Doc */
PyDoc_STRVAR(r1124_Kw_doc, 
"psat(T: array-like) --> mview \n\n"
"Get the ionization constant.");

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

Py_buffer create_new_buffer(char *format, Py_ssize_t itemsize, Py_ssize_t ndim, Py_ssize_t *shape){
    Py_buffer buffer;
    Py_ssize_t i, j, size, subsize;
    Py_ssize_t *strides = (Py_ssize_t *)PyMem_Calloc(ndim, sizeof(Py_ssize_t));

    buffer.obj = NULL;
    buffer.suboffsets = NULL;
    buffer.format = format;
    buffer.readonly = 0;
    buffer.itemsize = itemsize;
    buffer.ndim = ndim;
    buffer.shape = shape;

    size = 1;
    for(i=0; i<ndim; i++){
        size *= shape[i];
    }

    strides[ndim-1] = itemsize;
    if(ndim > 1){
        for(i=0; i<(ndim-1); i++){
            subsize = 1;
            for(j=i+1; j<ndim; j++){
                subsize *= shape[j];
            }
            strides[i] = subsize * itemsize;
        }
    }

    buffer.len = size * itemsize;
    buffer.strides = strides;
    buffer.buf = PyMem_Calloc(size, itemsize);

    return buffer;
}

Py_buffer *get_buffer(PyObject *o){
    PyObject *mview;
    Py_buffer *buffer;

    if(PyObject_CheckBuffer(o)==1){
        mview = PyMemoryView_FromObject(o);
        buffer = PyMemoryView_GET_BUFFER(mview);
    
        if(strcmp(buffer->format, "d")!=0){
            return NULL;
        }else if(buffer->ndim>1){
            return NULL;
        }else if(buffer->ndim==0){
            return NULL;
        }else{
            return buffer;
        }
    }else{
        return NULL;
    }
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

static PyObject *r797_wp(PyObject *self, PyObject *args){
    PyObject *T_obj;
    PyObject *p_obj;

    PyObject *T_mview;
    PyObject *p_mview;
    PyObject *res_mview;
    
    Py_buffer *T_buf;
    Py_buffer *p_buf;
    Py_buffer res_buf;
    
    char *prop;
    
    if(!PyArg_ParseTuple(args, "OOs", &p_obj, &T_obj, &prop)){
        return NULL;
    }

    T_mview = PyMemoryView_FromObject(T_obj);
    p_mview = PyMemoryView_FromObject(p_obj);

    T_buf = PyMemoryView_GET_BUFFER(T_mview);
    p_buf = PyMemoryView_GET_BUFFER(p_mview);

    res_buf = newbuffer_like(T_buf);

    iapws_r797_wp((double *)p_buf->buf, (double *)T_buf->buf, prop, (double *) res_buf.buf, res_buf.shape[0], strlen(prop));

    res_mview = PyMemoryView_FromBuffer(&res_buf);
    return res_mview;
}

static PyObject *r797_wr(PyObject *self, PyObject *args){
    PyObject *T_obj;
    PyObject *p_obj;

    PyObject *T_mview;
    PyObject *p_mview;
    PyObject *res_mview;
    
    Py_buffer *T_buf;
    Py_buffer *p_buf;
    Py_buffer res_buf;
    
    if(!PyArg_ParseTuple(args, "OO", &p_obj, &T_obj)){
        return NULL;
    }
    
    T_mview = PyMemoryView_FromObject(T_obj);
    p_mview = PyMemoryView_FromObject(p_obj);

    T_buf = PyMemoryView_GET_BUFFER(T_mview);
    p_buf = PyMemoryView_GET_BUFFER(p_mview);

    res_buf = create_new_buffer("i", sizeof(int), T_buf->ndim, T_buf->shape);

    iapws_r797_wr((double *)p_buf->buf, (double *)T_buf->buf, (int *) res_buf.buf, res_buf.shape[0]);

    res_mview = PyMemoryView_FromBuffer(&res_buf);
    return res_mview;
}

static PyObject *r797_wph(PyObject *self, PyObject *args){
    PyObject *T_obj;
    PyObject *p_obj;

    PyObject *T_mview;
    PyObject *p_mview;
    PyObject *res_mview;
    
    Py_buffer *T_buf;
    Py_buffer *p_buf;
    Py_buffer res_buf;
    
    if(!PyArg_ParseTuple(args, "OO", &p_obj, &T_obj)){
        return NULL;
    }
    
    T_mview = PyMemoryView_FromObject(T_obj);
    p_mview = PyMemoryView_FromObject(p_obj);

    T_buf = PyMemoryView_GET_BUFFER(T_mview);
    p_buf = PyMemoryView_GET_BUFFER(p_mview);

    res_buf = create_new_buffer("c", sizeof(char), T_buf->ndim, T_buf->shape);

    iapws_r797_wph((double *)p_buf->buf, (double *)T_buf->buf, (char *) res_buf.buf, res_buf.shape[0]);

    res_mview = PyMemoryView_FromBuffer(&res_buf);
    return res_mview;
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

/* R1124 */
static PyObject *r1124_Kw(PyObject *self, PyObject *args){
    PyObject *T_obj;
    PyObject *rho_obj;

    PyObject *T_mview;
    Py_buffer *T_buffer;
    
    PyObject *rho_mview;
    Py_buffer *rho_buffer;

    PyObject *new_mview;
    Py_buffer newbuffer;
    
    if(!PyArg_ParseTuple(args, "OO", &T_obj, &rho_obj)){
        return NULL;
    }

    T_mview = PyMemoryView_FromObject(T_obj);
    T_buffer = PyMemoryView_GET_BUFFER(T_mview);
    
    rho_mview = PyMemoryView_FromObject(rho_obj);
    rho_buffer = PyMemoryView_GET_BUFFER(rho_mview);

    newbuffer = newbuffer_like(T_buffer);

    iapws_r1124_Kw(T_buffer->shape[0], (double *) T_buffer->buf, (double *)rho_buffer->buf, (double *) newbuffer.buf);
    new_mview = PyMemoryView_FromBuffer(&newbuffer);

    return new_mview;
}

static PyMethodDef myMethods[] = {
    {"psat", (PyCFunction) r797_psat, METH_VARARGS, r797_psat_doc},
    {"Tsat", (PyCFunction) r797_Tsat, METH_VARARGS, r797_Tsat_doc},
    {"wp", (PyCFunction) r797_wp, METH_VARARGS, r797_wp_doc},
    {"wr", (PyCFunction) r797_wr, METH_VARARGS, r797_wr_doc},
    {"wph", (PyCFunction) r797_wph, METH_VARARGS, r797_wph_doc},
    {"kh", (PyCFunction) g704_kh, METH_VARARGS, g704_kh_doc},
    {"kd", (PyCFunction) g704_kd, METH_VARARGS, g704_kd_doc},
    {"ngases", (PyCFunction) g704_ngases, METH_VARARGS, g704_ngases_doc},
    {"gases", (PyCFunction) g704_gases, METH_VARARGS, g704_gases_doc},
    {"gases2", (PyCFunction) g704_gases2, METH_VARARGS, g704_gases2_doc},
    {"Kw", (PyCFunction) r1124_Kw, METH_VARARGS, r1124_Kw_doc},
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
