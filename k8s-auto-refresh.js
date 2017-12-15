// ==UserScript==
// @name         K8S Auto Refresh
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Press R to toggle page auto refresh on Kubernetes console
// @author       Raymond Chen
// @match        http://192.168.99.100:8080/api/v1/namespaces/kube-system/services/kubernetes-dashboard/*
// ==/UserScript==
var refreshInterval=15; // seconds

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) === 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

(function() {
    'use strict';
    var autoRefresh=getCookie('autoRefresh');
    if (autoRefresh === 'true') {
      var clusterElements=document.getElementsByClassName("kd-logo-bar");
      clusterElements[0].innerHTML+="♺️♺️♺️";
    }
    setTimeout(function(){
        if (autoRefresh === 'true')
            location.reload();
    }, refreshInterval*1000);
    document.onkeypress = function (e) {
    e = e || window.event;
    if (e.keyCode == 114 ) {
        if (autoRefresh === 'true') {
            setCookie('autoRefresh','false',1);
        } else {
            setCookie('autoRefresh','true',1);
        }
        setTimeout(function(){
            location.reload();
        }, 100);
    }
};

})();