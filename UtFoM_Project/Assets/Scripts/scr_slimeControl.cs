using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_slimeControl : MonoBehaviour
{
    public float moveSpeed, idleTime, moveTime, reloadTime;
    private bool slimeMovement, levelReload;
    private float idleCount, moveCount;
    private Vector3 moveDir;
    private Rigidbody2D body;
    private GameObject player;

    private void OnCollisionEnter2D(Collision2D collision)
    {
        /*if (collision.gameObject.name == "obj_player")
        {
            collision.gameObject.SetActive(false);
            levelReload = true;
            player = collision.gameObject;
        }*/
    }

    // Use this for initialization
    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        //idleCount = idleTime;
        //moveCount = moveTime;
    }
	
	// Update is called once per frame
	void Update()
    {
		if (slimeMovement)
        {
            moveCount -= Time.deltaTime;
            body.velocity = moveDir;
            if (moveCount <= 0f)
            {
                slimeMovement = false;
                //idleCount = idleTime;
                idleCount = Random.Range(idleTime * 0.75f, idleTime * 1.25f);
            }
        }
        else
        {
            body.velocity = Vector2.zero;
            idleCount -= Time.deltaTime;
            if (idleCount <= 0f)
            {
                slimeMovement = true;
                //moveCount = moveTime;
                moveCount = Random.Range(moveTime * 0.75f, moveTime * 1.25f);
                moveDir = new Vector3(Random.Range(-1f, 1f) * moveSpeed, Random.Range(-1f, 1f) * moveSpeed, 0f);
            }
        }

        if (levelReload)
        {
            reloadTime -= Time.deltaTime;
            if (reloadTime <= 0)
            {
                Application.LoadLevel(Application.loadedLevel);
                player.SetActive(true);
            }
        }
	}
}
