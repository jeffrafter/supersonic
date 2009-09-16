import com.macromedia.javascript.JavaScriptSerializer;
import com.macromedia.javascript.JavaScriptProxy;

class Supersonic {
  static var proxy:JavaScriptProxy; 

  function Supersonic() {
    proxy = new JavaScriptProxy(_root.lcId,this);  

    // creates a 'tf' TextField size 800x600 at pos 0,0
    _root.createTextField("tf",0,0,0,800,600);
    // write some text into it
    _root.tf.text = "Hello";

    _root.onEnterFrame = function () {
      if( (_root.fadeout_sound==1) ) {
        _root.sound.setVolume(_root.fadeout_sound_volume);
        _root.fadeout_sound_volume = _root.fadeout_sound_volume-3;
        if( (_root.fadeout_sound_volume<2) ) {
          _root.sound.stop();
          _root.fadeout_sound = 0;
          if( !_root.fadesound ) {
            return undefined;
          }
          _root.sound = _root.fadesound;
          _root.sound.onSoundComplete = function () {
            if( _root.sound ) {
              _root.sound.start(0,99);
            }
          };
          _root.fadesound = null;
        }
      }
      if( (_root.fadeout_effect==1) ) {
        _root.effect.setVolume(_root.fadeout_effect_volume);
        _root.fadeout_effect_volume = _root.fadeout_effect_volume-8;
        if( (_root.fadeout_effect_volume<2) ) {
          _root.effect.stop();
          _root.fadeout_effect = 0;
          if( !_root.fadeeffect ) {
            return undefined;
          }
          _root.effect = _root.fadeeffect;
          _root.fadeeffect = null;
        }
      }
    };
  }

  // Entry point, check if we should act like a proxy call
  static function main(context) {
    if (context.mode != "proxy") {
      var instance = new Supersonic();
    } else {
      var sending_lc:LocalConnection;
      if(_root.lcId != undefined)
      {
        sending_lc = new LocalConnection();
        
        //create the arguments array for the function call.
        var argsArray:Array = parseVars();
        
        if(argsArray != undefined && argsArray.length > 0)
        {
          //call the proxy function in the JavaScriptProxy instance in the main app / content
          sending_lc.send(_root.lcId, "callFlash", argsArray);
        }
        
        //close the connection
        sending_lc.close();
      }
    }
  }

  static function parseVars():Array {    
    if(_root.functionName == undefined) {
      trace("Warning : functionName not defined. Exiting.");
      return undefined;
    }
    var outArray:Array = new Array();
    
    outArray.push(_root.functionName);
    
    var index:Number = 0;
    
    var type:String;
    var data:String;
    
    while((type = _root["t" + index]) != undefined) {
      data = _root["d" + index];
      
      //deserialize into native ActionScript types
      outArray.push(JavaScriptSerializer.deserializeItem(type, data));
      index++;
    }
    
    return outArray;
  }


  function playSound(itemURL) {
    _root.fadeout_sound_volume = 100;
    _root.fadeout_sound = 0;
    _root.sound = new Sound();
    _root.sound.loadSound(itemURL,true);
    _root.sound.onSoundComplete = function () {

      // creates a 'tf' TextField size 800x600 at pos 0,0
      _root.createTextField("tf",0,0,0,800,600);
      // write some text into it
      _root.tf.text = "Hello worlds!";
      
      Supersonic.proxy.call("alert", "1");

      _root.sound.start(0,99);
    };
  }
  function stopSound() {
    _root.sound.onSoundComplete = null;
    _root.fadeout_sound_volume = 100;
    _root.fadeout_sound = 1;
  }

  function crossfadeSound(itemURL) {
    if( !_root.sound ) {
      playSound(itemURL);
      return undefined;
    }
    _root.sound.onSoundComplete = null;
    _root.fadeout_sound_volume = 100;
    _root.fadeout_sound = 1;
    _root.fadesound = new Sound();
    _root.fadesound.loadSound(itemURL,true);
  }

  function playEffect(itemURL) {
    _root.fadeout_effect_volume = 100;
    _root.fadeout_effect = 0;
    _root.effect = new Sound();
    _root.effect.loadSound(itemURL,true);
  }

  function stopEffect() {
    _root.effect.onSoundComplete = null;
    _root.fadeout_effect_volume = 100;
    _root.fadeout_effect = 1;
  }

  function crossfadeEffect(itemURL) {
    if( !_root.effect ) {
      playEffect(itemURL);
      return undefined;
    }
    _root.effect.onSoundComplete = null;
    _root.fadeout_effect_volume = 100;
    _root.fadeout_effect = 1;
    _root.fadeeffect = new Sound();
    _root.fadeeffect.loadSound(itemURL,true);
  }

};