--
-- Query to translate term in SQL query
--
CREATE OR REPLACE FUNCTION get_trad(langue varchar, typ varchar, nom varchar, texte varchar) RETURNS varchar AS $$
    DECLARE
        resultat text;
        resultat1 text;
 
    BEGIN
        IF texte is not null then
            select into resultat value::text from ir_translation where lang=langue and type=typ and name=nom and src=texte;
        ELSE
            select into resultat value::text from ir_translation where lang=langue and type=typ and name=nom;
        END IF;
        IF NOT FOUND THEN
            RETURN texte;
        ELSE
            RETURN resultat;
        END IF;
    END;
$$ LANGUAGE plpgsql;

--
-- Base translation to there id, better match query.
--
CREATE OR REPLACE FUNCTION get_trad(lang varchar, model varchar, field varchar, id integer, defval varchar) RETURNS varchar AS $$
    DECLARE
        resultat text;

    BEGIN
        IF id IS NOT NULL THEN
            SELECT INTO resultat value::text 
            FROM  ir_translation 
            WHERE lang=lang 
            AND   type='model' 
            AND   name=model||','||field 
            AND   res_id=id;
        ELSE
            RETURN defval;
        END IF;

        IF NOT FOUND THEN
            RETURN defval;
        ELSE
            RETURN resultat;
        END IF;
    END;
$$ LANGUAGE plpgsql;
