using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_loadStartPoint : MonoBehaviour
{
    public string startName;
    private scr_playerControl player;
    private scr_mainCamControl cam;

    // Use this for initialization
    void Start()
    {
        player = FindObjectOfType<scr_playerControl>();
        cam = FindObjectOfType<scr_mainCamControl>();

        if (player.startName == startName)
        {
            player.transform.position = transform.position;
            cam.transform.position = new Vector3(transform.position.x, transform.position.y, cam.transform.position.z);
        }
    }
	// Update is called once per frame
	void Update()
    {
		
	}
}
