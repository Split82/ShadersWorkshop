using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView, ExecuteInEditMode]
public class DOF : MonoBehaviour {

    [SerializeField] Material _blurMaterial;
    [SerializeField] Material _DOFMaterial;

    void OnRenderImage(RenderTexture src, RenderTexture dest) {

        var tempTexture0 = RenderTexture.GetTemporary(src.width / 2, src.height / 2, 0, RenderTextureFormat.Default);
        var tempTexture1 = RenderTexture.GetTemporary(src.width / 4, src.height / 4, 0, RenderTextureFormat.Default);
        var tempTexture2 = RenderTexture.GetTemporary(src.width / 4, src.height / 4, 0, RenderTextureFormat.Default);
        var blurTex = RenderTexture.GetTemporary(src.width / 4, src.height / 4, 0, RenderTextureFormat.Default);

        Graphics.Blit(src, tempTexture0, _blurMaterial, 2);
        Graphics.Blit(tempTexture0, tempTexture1, _blurMaterial, 2);
        Graphics.Blit(tempTexture1, tempTexture2, _blurMaterial, 0);
        Graphics.Blit(tempTexture2, blurTex, _blurMaterial, 1);        

        RenderTexture.ReleaseTemporary(tempTexture0);
        RenderTexture.ReleaseTemporary(tempTexture1);
        RenderTexture.ReleaseTemporary(tempTexture2);

        _DOFMaterial.SetTexture("_BlurTex", blurTex);
        Graphics.Blit(src, dest, _DOFMaterial);

        RenderTexture.ReleaseTemporary(blurTex);
    }
}