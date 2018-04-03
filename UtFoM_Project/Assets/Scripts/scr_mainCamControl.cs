using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_mainCamControl : MonoBehaviour
{
    public float moveSpeed;
    public GameObject followTarget;
    private static bool camExists = false;
    private Vector3 targetPosition;

	// Use this for initialization
	void Start()
    {
        DontDestroyOnLoad(transform.gameObject);

        if (!camExists)
        {
            camExists = true;
            DontDestroyOnLoad(transform.gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
	
	// Update is called once per frame
	void Update()
    {
        targetPosition = new Vector3(followTarget.transform.position.x, followTarget.transform.position.y,
           transform.position.z);
        transform.position = Vector3.Lerp(transform.position, targetPosition, moveSpeed * Time.deltaTime);
    }
}
