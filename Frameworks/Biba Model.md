A model used to achieve [[CIA Triad#Integrity|Integrity]]. This model applies the rule to objects (data) and subjects (users) that can be summarized as "no write up, no read down". Meaning that subjects can create or write content to objects at or below their level but can only read the contents of objects above the subject's level.

|   |   |
|---|---|
|**Advantages**|**Disadvantages**|
|This model is simple to implement.|There will be many levels of access and objects. Things can be easily overlooked when applying security controls.|
|Resolves the limitations of the [[Bell-La Padula Model]] by addressing both confidentiality and data integrity.|Often results in delays within a business. For example, a doctor would not be able to read the notes made by a nurse in a hospital with this model.|