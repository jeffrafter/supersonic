import com.macromedia.javascript.JavaScriptSerializer;
import com.macromedia.javascript.JavaScriptProxy;

class Supersonic {
  static var proxy:com.macromedia.javascript.JavaScriptProxy; 

  function Supersonic() {
    proxy = new com.macromedia.javascript.JavaScriptProxy(_root.lcId,this);  

		// creates a 'tf' TextField size 800x600 at pos 0,0
		_root.createTextField("tf",100,100,0,800,600);
		// write some text into it
		_root.tf.text = "Supersonic";

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
    if (context.proxy == undefined) {
      var instance = new Supersonic();
    } else {
      var instance = new JavaScriptProxy();
    }
  }

  function playSound(itemURL /*=R2*/ ) {
		// creates a 'tf' TextField size 800x600 at pos 0,0
		_root.createTextField("tf",0,0,0,800,600);
		// write some text into it
		_root.tf.text = "Hello world !";


    _root.fadeout_sound_volume = 100;
    _root.fadeout_sound = 0;
    _root.sound = new Sound();
    _root.sound.loadSound(itemURL,true);
    _root.sound.onSoundComplete = function () {
      _root.sound.start(0,99);
    };
  }
  function stopSound() {
    _root.sound.onSoundComplete = null;
    _root.fadeout_sound_volume = 100;
    _root.fadeout_sound = 1;
  }
  function crossfadeSound(itemURL /*=R2*/ ) {
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
  function playEffect(itemURL /*=R2*/ ) {
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
  function crossfadeEffect(itemURL /*=R2*/ ) {
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