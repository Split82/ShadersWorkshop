using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView, ExecuteInEditMode]
public class ImageEffect : MonoBehaviour {

    [SerializeField] Material _material;

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
         
        Graphics.Blit(src, dest, _material);
    }
}