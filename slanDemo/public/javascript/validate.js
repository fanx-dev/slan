var errMsg = {

  required: {
    msg: "This field is reuired.",
    test: function(obj, load) {
      var b = obj.value.length > 0 || load;
      return b
    }
  },

  email: {
    msg: "Not a valid email address.",
    test: function(obj) {
      return !obj.value ||
       /^(?:\w+\.?)*\w+@(?:\w+\.?)*\w+$/i.test(obj.value);
    }
  },

  id: {
    msg: "Not a valid ID. start with char and length in [3..36]",
    test: function(obj) {
      return !obj.value ||
      /[a-zA-Z0-9_-]{3,36}/.test(obj.value);
    }
  },

  uri: {
    msg: "Not a valid RUI.",
    test: function(obj) {
      return !obj.value ||
      /(\w+):\/\/([^\/:]+)(:\d*)?([^#]*)/.test(obj.value);
    }
  },

  digit: {
    msg: "Not a valid Digit",
    test: function(obj) {
      return !obj.value || /\d/.test(obj.value);
    }
  },

  date: {
    msg: "Not a valid Date",
    test: function(obj) {
      return !obj.value || /^(\d{4})\-(\d{2})\-(\d{2})$/.test(obj.value);
    }
  }
}

function validateForm(form, load) {
  var valid = true;
  for (var i=0; i < form.elements.length; i++) {

    if (!validateField(form.elements[i], load)){
      valid = false;
    }
  }
  return valid;
}

function validateField(elem, load) {
  hideErrors(elem);

  var errors = [];
  for (var name in errMsg) {
    var re = new RegExp("(^|\\s)" +name + "(\\s|$)");
    if (re.test(elem.className) && !errMsg[name].test(elem, load)){
      errors.push(errMsg[name].msg);
    }

    //console.debug(elem.className)
  }

  if (errors.length)
    showErrors(elem, errors);

  return errors.length == 0;
}

function hideErrors(elem){
  var next = elem.nextSibling;
  if (next && next.nodeName == "UL" && next.className == "errors"){
    elem.parentNode.removeChild(next);
    //console.debug("hide")
  }
}

function showErrors(elem, errors) {
  var next = elem.nextSibling;
  if (next && (next.nodeName != "UL" || next.className != "errors")){
    next = document.createElement("ul");
    next.className = "errors";
    elem.parentNode.insertBefore(next, elem.nextSibling);
  }

  for (var i=0; i < errors.length; i++) {
    var li = document.createElement("li");
    li.innerHTML = errors[i];
    next.appendChild(li);
  }
}

function watchFields(form){
  for (var i=0; i < form.elements.length; i++) {
    form.elements[i].onchange = function(){
      return validateField(this);
    };
  }
}

function watchForm(form){
  form.onsubmit = function() {
    return validateForm(form);
  }
}