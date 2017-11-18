using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotate_L: MonoBehaviour {

	void Update()
		{
			// Rotate the object around its local X axis at 1 degree per second
//			transform.Rotate(Vector3. * Time.deltaTime);
		    transform.Translate(Vector3.left * Time.deltaTime, Space.World);
		}
	}