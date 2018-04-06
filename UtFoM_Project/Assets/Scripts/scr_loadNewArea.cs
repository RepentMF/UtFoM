using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class scr_loadNewArea : MonoBehaviour
{
    public string newAreaName;
    public string exitName;
    private scr_playerControl player;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.name == "obj_player")
        {
            SceneManager.LoadScene(newAreaName);
        }
    }

    // Use this for initialization
    void Start()
    {
        player = FindObjectOfType<scr_playerControl>();
	}
	
	// Update is called once per frame
	void Update()
    {
        player.startName = exitName;
	}
}
