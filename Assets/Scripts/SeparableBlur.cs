using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView, ExecuteInEditMode]
public class SeparableBlur : MonoBehaviour {

    [SerializeField] Material _material;

    void OnRenderImage(RenderTexture src, RenderTexture dest) {

        var tempTexture0 = RenderTexture.GetTemporary(src.width / 2, src.height / 2, 0, RenderTextureFormat.Default);
        var tempTexture1 = RenderTexture.GetTemporary(src.width / 2, src.height / 2, 0, RenderTextureFormat.Default);                

        Graphics.Blit(src, tempTexture0, _material, 2);
        Graphics.Blit(tempTexture0, tempTexture1, _material, 0);
        Graphics.Blit(tempTexture1, dest, _material, 1);        

        RenderTexture.ReleaseTemporary(tempTexture0);
        RenderTexture.ReleaseTemporary(tempTexture1);
    }
}