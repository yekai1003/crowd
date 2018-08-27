var crowdAbi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "kccaddr",
				"type": "address"
			},
			{
				"name": "mvcAddr",
				"type": "address"
			}
		],
		"name": "setKccAddr",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_kccUnit",
				"type": "uint256"
			},
			{
				"name": "_mvcUnit",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAddr",
		"outputs": [
			{
				"name": "kccaddr",
				"type": "address"
			},
			{
				"name": "mvcaddr",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];