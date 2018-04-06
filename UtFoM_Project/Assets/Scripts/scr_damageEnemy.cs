using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_damageEnemy : MonoBehaviour
{
    public int damage;
    public GameObject damageParticleEffect;
    public GameObject display;
    public Transform particleEffectSpace;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "enemy")
        {
            collision.gameObject.GetComponent<scr_enemyHealthControl>().damageEnemy(damage);
            Instantiate(damageParticleEffect, particleEffectSpace.position, particleEffectSpace.rotation);

            var clone = (GameObject) Instantiate(display, particleEffectSpace.position, Quaternion.Euler (Vector3.zero));
            clone.GetComponent<scr_damageNumbers>().damage = damage;
            clone.transform.position = particleEffectSpace.position;
        }
    }

    // Use this for initialization
    void Start ()
    {
		
	}
	
	// Update is called once per frame
	void Update ()
    {

	}
}
