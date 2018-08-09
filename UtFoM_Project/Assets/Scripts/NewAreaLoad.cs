using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class NewAreaLoad : MonoBehaviour 
{
    public string levelToLoad;

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player") && Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene(levelToLoad);
        }
        else
        {
            Debug.Log("not working");
        }
    }

    void OnTriggerStay2D(Collider2D collision)
    {
        if (collision.CompareTag("Player") && Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene(levelToLoad);
        }
        else
        {
            Debug.Log("not working");
        }
    }

    // Use this for initialization
    void Start() 
	{
		
	}
	
	// Update is called once per frame
	void Update() 
	{
		
	}
}
