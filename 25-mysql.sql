-- https://raw.githubusercontent.com/sakaiproject/sakai/master/samigo/docs/auto_submit/auto_submit_mysql.sql

INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES (NULL, 1, 'automaticSubmission_isInstructorEditable', 'true');

-- Run these SQL commands to update the templates
CREATE TEMPORARY TABLE UPDATE_SAM_AUTO_IDS AS (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TYPEID='142' AND ISTEMPLATE=1);
-- You may need to clean this up if you've run it multiple times
-- DELETE FROM SAM_ASSESSMETADATA_T WHERE ASSESSMENTID IN (SELECT ID FROM UPDATE_SAM_AUTO_IDS) AND LABEL='automaticSubmission_isInstructorEditable';
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) SELECT NULL, ID, 'automaticSubmission_isInstructorEditable', 'true' FROM UPDATE_SAM_AUTO_IDS;
DROP TABLE UPDATE_SAM_AUTO_IDS;


-- Run these SQL commands to back fill to your existing assessments
CREATE TEMPORARY TABLE UPDATE_SAM_AUTO_IDS AS (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE ID NOT IN (SELECT ASSESSMENTID FROM SAM_ASSESSMETADATA_T WHERE label = 'automaticSubmission_isInstructorEditable'));
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) SELECT NULL, ID, 'automaticSubmission_isInstructorEditable', 'true' FROM UPDATE_SAM_AUTO_IDS;
DROP TABLE UPDATE_SAM_AUTO_IDS;

-- Add automatic link to WarpWire nightly
INSERT INTO `lti_tools` (`SITE_ID`, `title`, `fa_icon`, `description`, `status`, `visible`, `deployment_id`, `launch`, `consumerkey`, `secret`, `frameheight`, `siteinfoconfig`, `sendname`, `sendemailaddr`, `allowoutcomes`, `allowroster`, `pl_launch`, `pl_linkselection`, `pl_contenteditor`, `pl_importitem`, `pl_fileitem`, `pl_assessmentselection`, `newpage`, `debug`, `custom`, `lti13`, `lti13_settings`, `xmlimport`, `splash`, `created_at`, `updated_at`, `pl_lessonsselection`) 
VALUES
(NULL, 'WarpWire Test Server', NULL, NULL, 0, 0,  NULL, 'https://sakainightly.warpwire.net/api/ltix/?mode=plugin', 'lti:sakainightly:01', 'gsAM:wUeZRn2-kJERm-OkqrKB-nJxdke-webMOj-pj8vL2', NULL, 0, 1, 1, 1, 1, NULL, 1, 1, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NOW(), NOW(), 1);
 
INSERT INTO `lti_tools` (`SITE_ID`, `title`, `fa_icon`, `description`, `status`, `visible`, `deployment_id`, `launch`,  `consumerkey`,  `secret`,  `frameheight`, `siteinfoconfig`, `sendname`, `sendemailaddr`, `allowoutcomes`, `allowroster`, `pl_launch`, `pl_linkselection`, `pl_contenteditor`, `pl_importitem`, `pl_fileitem`, `pl_assessmentselection`, `newpage`, `debug`, `custom`, `lti13`, `lti13_settings`, `xmlimport`, `splash`, `created_at`, `updated_at`, `pl_lessonsselection`) 
VALUES
(NULL, 'TsugiCloud App Store', NULL, NULL, 0, 0,  NULL, 'https://test.tsugicloud.org/tsugi/lti/store/', '12345', 'secret', NULL, 0, 1, 1, 1, 1, NULL, 1, 1, NULL, NULL, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NOW(), NOW(), 1);

INSERT INTO `lti_tools` (`SITE_ID`, `title`, `fa_icon`, `description`, `status`, `visible`,
`deployment_id`, `launch`,  `consumerkey`,  `secret`,  
`frameheight`, `siteinfoconfig`, `sendname`, `sendemailaddr`, `allowoutcomes`, `allowlineitems`, `allowroster`, 
`pl_launch`, `pl_linkselection`, `pl_coursenav`, `pl_contenteditor`, `pl_importitem`, `pl_fileitem`, `pl_assessmentselection`,`pl_lessonsselection`,
`newpage`, `debug`, `custom`, `lti13`, `lti13_settings`, `xmlimport`, `splash`,
`created_at`, `updated_at`) 
VALUES
(NULL, 'Sakai Tsugicloud Trophy', 'fa-trophy', NULL, 0, 0,
NULL, 'https://sakai.tsugicloud.org/mod/trophy/', '12345', 'secret', 
1200, 0, 1, 1, 1, 1, 1,
1, 0, 1, 1, 0, 0, 1, 1,
2, 0, NULL, 0, NULL, NULL, NULL,
NOW(), NOW());
