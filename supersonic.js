
/*  Supersonic, version 0.0.1
 *  (c) 2009 Jeff Rafter
 *
 *  This product includes software developed by Macromedia, Inc.              
 *    (http://www.macromedia.com) Please see licence for details.             
 *
 *--------------------------------------------------------------------------*/
var Supersonic = {
  version: '0.0.1'
};

Supersonic = function() {
  
  // Initialize the audio 
  
  this.init = function(options) {
    // Where is the source
    this.movie = '../supersonic.swf';    

    // Proxy instance?
    if (options.lcId) {      
      this.lcId = options.lcId
      return;
    }
    this.lcId = new Date().getTime();
    this.proxy = new Supersonic()
    this.proxy.init({lcId:this.lcId});
    document.write(this.build(''));

    this.src = options.src || null;
    this.autobuffer = options.autobuffer || true;
    this.autoplay = options.autoplay || false;
    this.loop = options.loop || false;
    if (this.autobuffer) this.load();
  }
  
  // Tag building interface for the actual movie
  
  this.build = function(vars) {
    var ie = (navigator.appName.indexOf ("Microsoft") != -1) ? 1 : 0;
    var flash = new String();
    if (ie)
    {
        flash += '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" ';
        flash += 'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version='+Supersonic.version+'" ';
        flash += 'width="200" ';
        flash += 'height="200">';
        flash += '<param name="movie" value="'+this.movie+'"/>';
        flash += '<param name="quality" value="high"/>';
        flash += '<param name="flashvars" value="'+vars+'"/>';
        flash += '</object>';
    }
    else
    {
        flash += '<embed src="'+this.movie+'" ';
        flash += 'quality="high" '; 
        flash += 'width="200" ';
        flash += 'height="200" ';
        flash += 'type="application/x-shockwave-flash" ';
        flash += 'flashvars="'+vars+'" ';
        flash += 'pluginspage="http://www.macromedia.com/go/getflashplayer">';
        flash += '</embed>';
    }
    return flash;  
  }

  this.load = function() {}
  this.play = function() { this.proxy.call('playSound', this.src); }
  this.pause = function() {}
  this.stop = function() { this.proxy.call('stopSound'); }
  this.mute = function() {}
  this.unmute = function() {}
  this.volume = function(level) {}
  this.fade = function(to, duration) {}

  // Serialization interface for the flash plugin
  
  this.serialize = function(args)
  {
    var qs = new String();
    
    for (var i = 0; i < args.length; ++i)
    {
      switch(typeof(args[i])) {
        case 'undefined':
          qs += 't'+(i)+'=undf';
          break;
        case 'string':
          qs += 't'+(i)+'=str&d'+(i)+'='+escape(args[i]);
          break;
        case 'number':
          qs += 't'+(i)+'=num&d'+(i)+'='+escape(args[i]);
          break;
        case 'boolean':
          qs += 't'+(i)+'=bool&d'+(i)+'='+escape(args[i]);
          break;
        case 'object':
          if (args[i] == null) {
            qs += 't'+(i)+'=null';
          }
          else if (args[i] instanceof Date) {
            qs += 't'+(i)+'=date&d'+(i)+'='+escape(args[i].getTime());
          } else {
            throw "Unsupported serialization type";
          }  
          break;
        default:
          throw "Unsupported serialization type";
      }

      if (i != (args.length - 1)) {
        qs += '&';
      }
    }
    return qs;
  }

  // Proxy behavior

  this.call = function() {
    if (arguments.length == 0) throw("Flash Proxy Exception");
    var args = new Array();
    for (var i = 0; i < arguments.length; i++) args.push(arguments[i]);
    var name = args.shift();
    var query = 'proxy=1&lcId=' + escape(this.lcId) + '&functionName=' + escape(name);
    if (args.length > 0) query += ('&' + this.serialize(args));
    var id = '_flash_proxy_' + this.lcId;
    var target = document.getElementById(id);
    if(!target) {
      target = document.createElement("div");
      target.id = id;
      document.body.appendChild(target);
    }
    target.innerHTML = this.build(query)    
  }  
  
  this.js = function() {
    var functionToCall = eval(arguments.shift());
    functionToCall.apply(functionToCall, arguments);
  }
}