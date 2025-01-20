// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

service on new http:Listener(9090) {
    resource function post .(@http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject {
        SimplePublicObject responseBody = {
            "createdAt": "2025-01-19T07:50:07.832Z",
            "archived": false,
            "id": "19247563141",
            "properties": {
                "hs_ticket_category": null,
                "hs_ticket_priority": "LOW",
                "hs_lastmodifieddate": "2025-01-19T07:50:07.832Z",
                "subject": "Auto generated Issue Report",
                "hs_object_id": "19247563141",
                "hs_pipeline": "0",
                "createdate": "2025-01-19T07:50:07.832Z",
                "hs_pipeline_stage": "1",
                "content": null
            },
            "updatedAt": "2025-01-19T07:50:07.832Z"
        };
        return responseBody;
    }

    resource function get .() returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging {
        CollectionResponseSimplePublicObjectWithAssociationsForwardPaging responseBody = {
            "paging": {
                "next": {
                    "link": "?after=NTI1Cg%3D%3D",
                    "after": "NTI1Cg%3D%3D"
                }
            },
            "results": [
                {
                    "associations": {
                        "additionalProp1": {
                            "paging": {
                                "next": null,
                                "prev": {
                                    "before": "string",
                                    "link": "string"
                                }
                            },
                            "results": [
                                {
                                    "id": "string",
                                    "type": "string"
                                }
                            ]
                        },
                        "additionalProp2": {
                            "paging": {
                                "next": null,
                                "prev": {
                                    "before": "string",
                                    "link": "string"
                                }
                            },
                            "results": [
                                {
                                    "id": "string",
                                    "type": "string"
                                }
                            ]
                        },
                        "additionalProp3": {
                            "paging": {
                                "next": null,
                                "prev": {
                                    "before": "string",
                                    "link": "string"
                                }
                            },
                            "results": [
                                {
                                    "id": "string",
                                    "type": "string"
                                }
                            ]
                        }
                    },
                    "createdAt": "2025-01-19T06:31:10.268Z",
                    "archived": true,
                    "archivedAt": "2025-01-19T06:31:10.268Z",
                    "propertiesWithHistory": {
                        "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-01-19T06:31:10.268Z"
                            }
                        ],
                        "additionalProp2": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-01-19T06:31:10.268Z"
                            }
                        ],
                        "additionalProp3": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-01-19T06:31:10.268Z"
                            }
                        ]
                    },
                    "id": "string",
                    "properties": {
                        "additionalProp1": "string",
                        "additionalProp2": "string",
                        "additionalProp3": "string"
                    },
                    "updatedAt": "2025-01-19T06:31:10.268Z"
                }
            ]
        };
        return responseBody;
    }

    resource function get [string id]() returns SimplePublicObjectWithAssociations {
        SimplePublicObjectWithAssociations responseBody = {
            "createdAt": "2025-01-19T07:50:07.832Z",
            "archived": false,
            "id": id,
            "properties": {
                "hs_ticket_category": null,
                "hs_ticket_priority": "LOW",
                "hs_lastmodifieddate": "2025-01-19T07:50:07.832Z",
                "subject": "Auto generated Issue Report",
                "hs_object_id": "19247563141",
                "hs_pipeline": "0",
                "createdate": "2025-01-19T07:50:07.832Z",
                "hs_pipeline_stage": "1",
                "content": null
            },
            "updatedAt": "2025-01-19T07:50:07.832Z"
        };
        return responseBody;
    }

};
