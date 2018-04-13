using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorSwitcher : MonoBehaviour {

    [SerializeField] Material _material;
    [SerializeField] Color _color0;
    [SerializeField] Color _color1;

    private int _colorID;

    void Start() {

        _colorID = Shader.PropertyToID("_Color");
    }

	void Update() {
        
        if (Input.GetKey(KeyCode.Space)) {
            _material.SetColor(_colorID, _color0);
        }
        else {
            _material.SetColor(_colorID, _color1);
        }
	}
}
