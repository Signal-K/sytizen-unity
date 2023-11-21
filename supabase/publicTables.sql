PGDMP  9                    {            postgres    15.1    16.0    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    5    postgres    DATABASE     p   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3212            �           0    0    DATABASE postgres    ACL     2   GRANT ALL ON DATABASE postgres TO dashboard_user;
                   postgres    false    3212            �           0    0    postgres    DATABASE PROPERTIES     �   ALTER DATABASE postgres SET "app.settings.jwt_secret" TO '5YZ2tjMP8Cr03qJWIss/J2sH4HUejYHLb6KIJ7H3wcxollPne4MZ7YMpD1HQNcsCgvOyTSjCj7ARros6cA5poQ==';
ALTER DATABASE postgres SET "app.settings.jwt_exp" TO '3600';
                     postgres    false                        2615    26985    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    ACL     �   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;
                   postgres    false    24            �           1255    27495    handle_new_user()    FUNCTION        CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;
 (   DROP FUNCTION public.handle_new_user();
       public          postgres    false    24            �           0    0    FUNCTION handle_new_user()    ACL     �   GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;
          public          postgres    false    485            �           1255    27119 '   install_available_extensions_and_test()    FUNCTION     ;  CREATE FUNCTION public.install_available_extensions_and_test() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE extension_name TEXT;
allowed_extentions TEXT[] := string_to_array(current_setting('supautils.privileged_extensions'), ',');
BEGIN 
  FOREACH extension_name IN ARRAY allowed_extentions 
  LOOP
    SELECT trim(extension_name) INTO extension_name;
    /* skip below extensions check for now */
    CONTINUE WHEN extension_name = 'pgroonga' OR  extension_name = 'pgroonga_database' OR extension_name = 'pgsodium';
    CONTINUE WHEN extension_name = 'plpgsql' OR  extension_name = 'plpgsql_check' OR extension_name = 'pgtap';
    CONTINUE WHEN extension_name = 'supabase_vault' OR extension_name = 'wrappers';
    RAISE notice 'START TEST FOR: %', extension_name;
    EXECUTE format('DROP EXTENSION IF EXISTS %s CASCADE', quote_ident(extension_name));
    EXECUTE format('CREATE EXTENSION %s CASCADE', quote_ident(extension_name));
    RAISE notice 'END TEST FOR: %', extension_name;
  END LOOP;
    RAISE notice 'EXTENSION TESTS COMPLETED..';
    return true;
END;
$$;
 >   DROP FUNCTION public.install_available_extensions_and_test();
       public          postgres    false    24            �           0    0 0   FUNCTION install_available_extensions_and_test()    ACL     �   GRANT ALL ON FUNCTION public.install_available_extensions_and_test() TO anon;
GRANT ALL ON FUNCTION public.install_available_extensions_and_test() TO authenticated;
GRANT ALL ON FUNCTION public.install_available_extensions_and_test() TO service_role;
          public          postgres    false    476            �           1255    28902    set_timestamp(uuid)    FUNCTION     �   CREATE FUNCTION public.set_timestamp(post_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE forumPosts 
    SET updated_at = NOW()
    WHERE id = post_id;
END;
$$;
 2   DROP FUNCTION public.set_timestamp(post_id uuid);
       public          postgres    false    24            �           0    0 $   FUNCTION set_timestamp(post_id uuid)    ACL     �   GRANT ALL ON FUNCTION public.set_timestamp(post_id uuid) TO anon;
GRANT ALL ON FUNCTION public.set_timestamp(post_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.set_timestamp(post_id uuid) TO service_role;
          public          postgres    false    414                       1259    27664    articles    TABLE     �   CREATE TABLE public.articles (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    title text,
    content text,
    user_id uuid,
    "classification/tic" bigint,
    tags jsonb
);
    DROP TABLE public.articles;
       public         heap    postgres    false    24            �           0    0    TABLE articles    COMMENT     :   COMMENT ON TABLE public.articles IS 'Long form articles';
          public          postgres    false    285            �           0    0    COLUMN articles.user_id    COMMENT     P   COMMENT ON COLUMN public.articles.user_id IS 'Who published the post?/article';
          public          postgres    false    285            �           0    0    COLUMN articles.tags    COMMENT     R   COMMENT ON COLUMN public.articles.tags IS 'Metadata tag/category of the article';
          public          postgres    false    285            �           0    0    TABLE articles    ACL     �   GRANT ALL ON TABLE public.articles TO anon;
GRANT ALL ON TABLE public.articles TO authenticated;
GRANT ALL ON TABLE public.articles TO service_role;
          public          postgres    false    285                       1259    27667    articles_id_seq    SEQUENCE     �   ALTER TABLE public.articles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    285            �           0    0    SEQUENCE articles_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.articles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.articles_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.articles_id_seq TO service_role;
          public          postgres    false    286            @           1259    29390    basePlanets    TABLE     �  CREATE TABLE public."basePlanets" (
    id bigint NOT NULL,
    content text,
    "ticId" text,
    type text,
    radius double precision,
    mass double precision,
    density double precision,
    gravity double precision,
    "temperatureEq" double precision,
    temperature double precision,
    smaxis double precision,
    orbital_period double precision,
    classification_status text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    deepnote text
);
 !   DROP TABLE public."basePlanets";
       public         heap    postgres    false    24            �           0    0    TABLE "basePlanets"    COMMENT     v   COMMENT ON TABLE public."basePlanets" IS 'Duplicate of `planetsss` table, but only for the initial static anomalies';
          public          postgres    false    320            �           0    0    TABLE "basePlanets"    ACL     �   GRANT ALL ON TABLE public."basePlanets" TO anon;
GRANT ALL ON TABLE public."basePlanets" TO authenticated;
GRANT ALL ON TABLE public."basePlanets" TO service_role;
          public          postgres    false    320            A           1259    29393    basePlanets_id_seq    SEQUENCE     �   ALTER TABLE public."basePlanets" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."basePlanets_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    320    24            �           0    0    SEQUENCE "basePlanets_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."basePlanets_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."basePlanets_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."basePlanets_id_seq" TO service_role;
          public          postgres    false    321            )           1259    28246    comments    TABLE     �   CREATE TABLE public.comments (
    id bigint NOT NULL,
    post_id bigint NOT NULL,
    parent_comment_id bigint,
    content text NOT NULL,
    author uuid NOT NULL,
    created_at timestamp with time zone
);
    DROP TABLE public.comments;
       public         heap    postgres    false    24            �           0    0    TABLE comments    ACL     �   GRANT ALL ON TABLE public.comments TO anon;
GRANT ALL ON TABLE public.comments TO authenticated;
GRANT ALL ON TABLE public.comments TO service_role;
          public          postgres    false    297            (           1259    28245    comments_id_seq    SEQUENCE     x   CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.comments_id_seq;
       public          postgres    false    297    24            �           0    0    comments_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;
          public          postgres    false    296            �           0    0    SEQUENCE comments_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.comments_id_seq TO anon;
GRANT ALL ON SEQUENCE public.comments_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.comments_id_seq TO service_role;
          public          postgres    false    296            ;           1259    29152    contentROVERIMAGES    TABLE     �   CREATE TABLE public."contentROVERIMAGES" (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata text,
    "imageLink" text,
    planet bigint,
    content text,
    author uuid,
    media json
);
 (   DROP TABLE public."contentROVERIMAGES";
       public         heap    postgres    false    24            �           0    0    TABLE "contentROVERIMAGES"    COMMENT     q   COMMENT ON TABLE public."contentROVERIMAGES" IS 'Content/posts made about rover images from the NASA Open APIs';
          public          postgres    false    315            �           0    0    TABLE "contentROVERIMAGES"    ACL     �   GRANT ALL ON TABLE public."contentROVERIMAGES" TO anon;
GRANT ALL ON TABLE public."contentROVERIMAGES" TO authenticated;
GRANT ALL ON TABLE public."contentROVERIMAGES" TO service_role;
          public          postgres    false    315            <           1259    29155    contentROVERIMAGES_id_seq    SEQUENCE     �   ALTER TABLE public."contentROVERIMAGES" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."contentROVERIMAGES_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    315    24            �           0    0 $   SEQUENCE "contentROVERIMAGES_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."contentROVERIMAGES_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."contentROVERIMAGES_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."contentROVERIMAGES_id_seq" TO service_role;
          public          postgres    false    316            1           1259    28697    inventoryITEMS    TABLE     /  CREATE TABLE public."inventoryITEMS" (
    id bigint NOT NULL,
    name character varying,
    description text,
    cost integer,
    icon_url character varying,
    "ItemCategory" text,
    "parentItem" bigint,
    "itemLevel" double precision DEFAULT '1'::double precision,
    "oldAssets" text[]
);
 $   DROP TABLE public."inventoryITEMS";
       public         heap    postgres    false    24            �           0    0 $   COLUMN "inventoryITEMS"."parentItem"    COMMENT     o   COMMENT ON COLUMN public."inventoryITEMS"."parentItem" IS 'Some items are related to each other, levels, etc';
          public          postgres    false    305            �           0    0 #   COLUMN "inventoryITEMS"."itemLevel"    COMMENT     Y   COMMENT ON COLUMN public."inventoryITEMS"."itemLevel" IS 'What iteration is this item?';
          public          postgres    false    305            �           0    0 #   COLUMN "inventoryITEMS"."oldAssets"    COMMENT     Y   COMMENT ON COLUMN public."inventoryITEMS"."oldAssets" IS 'Have asset/textures changed?';
          public          postgres    false    305            �           0    0    TABLE "inventoryITEMS"    ACL     �   GRANT ALL ON TABLE public."inventoryITEMS" TO anon;
GRANT ALL ON TABLE public."inventoryITEMS" TO authenticated;
GRANT ALL ON TABLE public."inventoryITEMS" TO service_role;
          public          postgres    false    305            2           1259    28700    inventoryITEMS_id_seq    SEQUENCE     �   ALTER TABLE public."inventoryITEMS" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."inventoryITEMS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    305    24            �           0    0     SEQUENCE "inventoryITEMS_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."inventoryITEMS_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."inventoryITEMS_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."inventoryITEMS_id_seq" TO service_role;
          public          postgres    false    306            8           1259    29013    inventoryOFSPACESHIP    TABLE     �   CREATE TABLE public."inventoryOFSPACESHIP" (
    id bigint NOT NULL,
    inventory_spaceship_id bigint,
    quantity bigint,
    item_id bigint
);
 *   DROP TABLE public."inventoryOFSPACESHIP";
       public         heap    postgres    false    24            �           0    0    TABLE "inventoryOFSPACESHIP"    ACL     �   GRANT ALL ON TABLE public."inventoryOFSPACESHIP" TO anon;
GRANT ALL ON TABLE public."inventoryOFSPACESHIP" TO authenticated;
GRANT ALL ON TABLE public."inventoryOFSPACESHIP" TO service_role;
          public          postgres    false    312            5           1259    28776    inventoryPLANETS    TABLE     �   CREATE TABLE public."inventoryPLANETS" (
    id bigint NOT NULL,
    planet_id bigint NOT NULL,
    owner_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    modifications character varying
);
 &   DROP TABLE public."inventoryPLANETS";
       public         heap    postgres    false    24            �           0    0    TABLE "inventoryPLANETS"    COMMENT     d   COMMENT ON TABLE public."inventoryPLANETS" IS 'Pointers for user-owned copies of base planets(ss)';
          public          postgres    false    309            �           0    0    TABLE "inventoryPLANETS"    ACL     �   GRANT ALL ON TABLE public."inventoryPLANETS" TO anon;
GRANT ALL ON TABLE public."inventoryPLANETS" TO authenticated;
GRANT ALL ON TABLE public."inventoryPLANETS" TO service_role;
          public          postgres    false    309            6           1259    28779    inventoryPLANETS_id_seq    SEQUENCE     �   ALTER TABLE public."inventoryPLANETS" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."inventoryPLANETS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    309    24            �           0    0 "   SEQUENCE "inventoryPLANETS_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."inventoryPLANETS_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."inventoryPLANETS_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."inventoryPLANETS_id_seq" TO service_role;
          public          postgres    false    310            9           1259    29091    inventorySPACESHIPS    TABLE     �   CREATE TABLE public."inventorySPACESHIPS" (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    owner uuid,
    spaceship_id bigint,
    state text,
    current_planet bigint
);
 )   DROP TABLE public."inventorySPACESHIPS";
       public         heap    postgres    false    24            �           0    0    TABLE "inventorySPACESHIPS"    COMMENT     O   COMMENT ON TABLE public."inventorySPACESHIPS" IS 'List of spaceships in-game';
          public          postgres    false    313            �           0    0    TABLE "inventorySPACESHIPS"    ACL     �   GRANT ALL ON TABLE public."inventorySPACESHIPS" TO anon;
GRANT ALL ON TABLE public."inventorySPACESHIPS" TO authenticated;
GRANT ALL ON TABLE public."inventorySPACESHIPS" TO service_role;
          public          postgres    false    313            7           1259    28991    inventorySPACESHIPS2    TABLE     �   CREATE TABLE public."inventorySPACESHIPS2" (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    owner uuid,
    spaceship_id bigint,
    state text,
    current_planet bigint
);
 *   DROP TABLE public."inventorySPACESHIPS2";
       public         heap    postgres    false    24            �           0    0    TABLE "inventorySPACESHIPS2"    ACL     �   GRANT ALL ON TABLE public."inventorySPACESHIPS2" TO anon;
GRANT ALL ON TABLE public."inventorySPACESHIPS2" TO authenticated;
GRANT ALL ON TABLE public."inventorySPACESHIPS2" TO service_role;
          public          postgres    false    311            :           1259    29094    inventorySPACESHIPS_id_seq    SEQUENCE     �   ALTER TABLE public."inventorySPACESHIPS" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."inventorySPACESHIPS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    313    24            �           0    0 %   SEQUENCE "inventorySPACESHIPS_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."inventorySPACESHIPS_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."inventorySPACESHIPS_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."inventorySPACESHIPS_id_seq" TO service_role;
          public          postgres    false    314            3           1259    28743    inventoryUSERS    TABLE     �   CREATE TABLE public."inventoryUSERS" (
    id bigint NOT NULL,
    item bigint,
    owner uuid,
    quantity double precision,
    location bigint
);
 $   DROP TABLE public."inventoryUSERS";
       public         heap    postgres    false    24            �           0    0    TABLE "inventoryUSERS"    COMMENT     V   COMMENT ON TABLE public."inventoryUSERS" IS 'Table for every instance of every item';
          public          postgres    false    307            �           0    0     COLUMN "inventoryUSERS".location    COMMENT     U   COMMENT ON COLUMN public."inventoryUSERS".location IS 'Where is this item located?';
          public          postgres    false    307            �           0    0    TABLE "inventoryUSERS"    ACL     �   GRANT ALL ON TABLE public."inventoryUSERS" TO anon;
GRANT ALL ON TABLE public."inventoryUSERS" TO authenticated;
GRANT ALL ON TABLE public."inventoryUSERS" TO service_role;
          public          postgres    false    307            4           1259    28746    inventoryUSERS_id_seq    SEQUENCE     �   ALTER TABLE public."inventoryUSERS" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."inventoryUSERS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    307    24            �           0    0     SEQUENCE "inventoryUSERS_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."inventoryUSERS_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."inventoryUSERS_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."inventoryUSERS_id_seq" TO service_role;
          public          postgres    false    308            '           1259    28046    lightkurves    TABLE     5  CREATE TABLE public.lightkurves (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    temperature bigint,
    content text,
    radius double precision,
    orbital_period double precision,
    image text,
    cover text,
    avatar_url text,
    owner text,
    contract text
);
    DROP TABLE public.lightkurves;
       public         heap    postgres    false    24            �           0    0    TABLE lightkurves    COMMENT     O   COMMENT ON TABLE public.lightkurves IS 'Duplicate of `planetsss` for testing';
          public          postgres    false    295            �           0    0    TABLE lightkurves    ACL     �   GRANT ALL ON TABLE public.lightkurves TO anon;
GRANT ALL ON TABLE public.lightkurves TO authenticated;
GRANT ALL ON TABLE public.lightkurves TO service_role;
          public          postgres    false    295                       1259    27561    planets    TABLE       CREATE TABLE public.planets (
    temperature real,
    date timestamp without time zone,
    "ticId" text,
    radius bigint,
    "userId" text,
    name text,
    id uuid NOT NULL,
    cover text,
    avatar_url text,
    contract text,
    "tokenId" text,
    "chainId" text,
    forks jsonb,
    "forkFrom" uuid,
    posts jsonb[],
    articles jsonb,
    datasets text[],
    generator jsonb,
    "ownerAddress" text,
    multiplier bigint,
    "isClaimed" boolean,
    "ownerId2" uuid,
    planetss bigint
);
    DROP TABLE public.planets;
       public         heap    postgres    false    24            �           0    0    COLUMN planets."ticId"    COMMENT     L   COMMENT ON COLUMN public.planets."ticId" IS 'Generated by the game engine';
          public          postgres    false    282            �           0    0    COLUMN planets.radius    COMMENT     H   COMMENT ON COLUMN public.planets.radius IS 'Radius of the KOI/tic OoI';
          public          postgres    false    282            �           0    0    COLUMN planets."userId"    COMMENT     s   COMMENT ON COLUMN public.planets."userId" IS 'Link to the username (will later be id) of the owner of the planet';
          public          postgres    false    282            �           0    0    COLUMN planets.name    COMMENT     8   COMMENT ON COLUMN public.planets.name IS 'Planet Name';
          public          postgres    false    282            �           0    0    COLUMN planets.id    COMMENT     L   COMMENT ON COLUMN public.planets.id IS 'Unique Identifier for each planet';
          public          postgres    false    282            �           0    0    COLUMN planets.cover    COMMENT     R   COMMENT ON COLUMN public.planets.cover IS 'Cover image (update behaviour later)';
          public          postgres    false    282            �           0    0    COLUMN planets.avatar_url    COMMENT     a   COMMENT ON COLUMN public.planets.avatar_url IS 'Avatar for planet, based on profile>avatar_url';
          public          postgres    false    282            �           0    0    COLUMN planets.contract    COMMENT     �   COMMENT ON COLUMN public.planets.contract IS 'Address of the planet. This is so that we can return fields to interact with a token (push/pull) on the frontend, like updating/adding metadata. ';
          public          postgres    false    282            �           0    0    COLUMN planets."tokenId"    COMMENT     S   COMMENT ON COLUMN public.planets."tokenId" IS 'd of the anomaly on the contract ';
          public          postgres    false    282            �           0    0    COLUMN planets."chainId"    COMMENT     O   COMMENT ON COLUMN public.planets."chainId" IS 'What chain is the address on?';
          public          postgres    false    282            �           0    0    COLUMN planets.forks    COMMENT     J   COMMENT ON COLUMN public.planets.forks IS 'Who has forked this anomaly?';
          public          postgres    false    282            �           0    0    COLUMN planets."forkFrom"    COMMENT     \   COMMENT ON COLUMN public.planets."forkFrom" IS 'What was the original Id of this anomaly?';
          public          postgres    false    282            �           0    0    COLUMN planets.posts    COMMENT     w   COMMENT ON COLUMN public.planets.posts IS 'What shortform/discussion posts & comments was this anomaly mentioned in?';
          public          postgres    false    282            �           0    0    COLUMN planets.articles    COMMENT     j   COMMENT ON COLUMN public.planets.articles IS 'What long-form discussions was this anomaly mentioned in?';
          public          postgres    false    282            �           0    0    COLUMN planets.datasets    COMMENT     �   COMMENT ON COLUMN public.planets.datasets IS 'What datasets was this anomaly part of? **add as foreign key when datasets table created**';
          public          postgres    false    282            �           0    0    COLUMN planets.generator    COMMENT     X   COMMENT ON COLUMN public.planets.generator IS 'fields returned from Flask + Generator';
          public          postgres    false    282            �           0    0    COLUMN planets.multiplier    COMMENT     �   COMMENT ON COLUMN public.planets.multiplier IS 'https://www.notion.so/elianna/Reputation-Generator-parameters-for-anomalies-data-points-73f334d3ab0b40ce900ee15e121006cf?pvs=4#e5b9cdc81e5644d59fc5cd56fc1dcb2c';
          public          postgres    false    282            �           0    0    COLUMN planets."isClaimed"    COMMENT     R   COMMENT ON COLUMN public.planets."isClaimed" IS 'Has this anomaly been claimed?';
          public          postgres    false    282            �           0    0    COLUMN planets."ownerId2"    COMMENT     K   COMMENT ON COLUMN public.planets."ownerId2" IS 'Test without foreign key';
          public          postgres    false    282            �           0    0    TABLE planets    ACL     �   GRANT ALL ON TABLE public.planets TO anon;
GRANT ALL ON TABLE public.planets TO authenticated;
GRANT ALL ON TABLE public.planets TO service_role;
          public          postgres    false    282                        1259    27810 	   planetsss    TABLE     �  CREATE TABLE public.planetsss (
    id bigint NOT NULL,
    content text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    media json DEFAULT '[]'::json,
    planets uuid,
    temperature text,
    "ownerAddress" text,
    avatar_url text,
    cover text,
    contract text,
    "ticId" text,
    orbital_period double precision DEFAULT '0'::double precision,
    radius double precision DEFAULT '0'::double precision,
    deepnote text,
    difficulty bigint,
    classification_status text DEFAULT 'incomplete'::text,
    metallicity double precision,
    luminosity double precision,
    mass double precision,
    color double precision
);
    DROP TABLE public.planetsss;
       public         heap    postgres    false    24            �           0    0    COLUMN planetsss.owner    COMMENT     K   COMMENT ON COLUMN public.planetsss.owner IS 'Owner/creator of the planet';
          public          postgres    false    288            �           0    0    COLUMN planetsss.media    COMMENT     w   COMMENT ON COLUMN public.planetsss.media IS 'By default, just photos uploaded as part of a post/proposal/publication';
          public          postgres    false    288            �           0    0    COLUMN planetsss.planets    COMMENT       COMMENT ON COLUMN public.planetsss.planets IS 'Does this post mention a planet? Should be updated to an array based on datapoints in datasets that are hosted on DeSci''s IPFS Nodes>>Orchid. Will be like an additional TIC id metadata tag on Lens publications/proposals';
          public          postgres    false    288            �           0    0    COLUMN planetsss.temperature    COMMENT     `   COMMENT ON COLUMN public.planetsss.temperature IS 'temperature of the anomaly > planet (in K)';
          public          postgres    false    288            �           0    0    COLUMN planetsss.contract    COMMENT     P   COMMENT ON COLUMN public.planetsss.contract IS 'Eth collection of the anomaly';
          public          postgres    false    288            �           0    0    COLUMN planetsss."ticId"    COMMENT     �   COMMENT ON COLUMN public.planetsss."ticId" IS 'https://deepnote.com/workspace/star-sailors-49d2efda-376f-4329-9618-7f871ba16007/project/Anomaly-Interaction-ab6b31e5-13c3-4949-af38-1197d00bd4d1/%2F.env';
          public          postgres    false    288            �           0    0    COLUMN planetsss.orbital_period    COMMENT     N   COMMENT ON COLUMN public.planetsss.orbital_period IS 'Period of the anomaly';
          public          postgres    false    288            �           0    0    COLUMN planetsss.radius    COMMENT     V   COMMENT ON COLUMN public.planetsss.radius IS 'radius of the predicted anomaly in km';
          public          postgres    false    288            �           0    0    COLUMN planetsss.deepnote    COMMENT     T   COMMENT ON COLUMN public.planetsss.deepnote IS 'Embed link for the deepnote block';
          public          postgres    false    288            �           0    0    COLUMN planetsss.difficulty    COMMENT     Z   COMMENT ON COLUMN public.planetsss.difficulty IS 'How difficult a planet is to classify';
          public          postgres    false    288            �           0    0 &   COLUMN planetsss.classification_status    COMMENT     �   COMMENT ON COLUMN public.planetsss.classification_status IS 'What''s the status of the classification? Just starting off with "incomplete", "in progress", or ''completed" for now';
          public          postgres    false    288            �           0    0    COLUMN planetsss.metallicity    COMMENT     �   COMMENT ON COLUMN public.planetsss.metallicity IS 'Metallicity typically refers to the abundance of elements heavier than helium in a star. It is often measured as the ratio of iron to hydrogen';
          public          postgres    false    288            �           0    0    COLUMN planetsss.luminosity    COMMENT     �   COMMENT ON COLUMN public.planetsss.luminosity IS 'Luminosity is the total amount of energy a star emits per unit of time. It can be measured in terms of solar luminosities (the Sun''s luminosity is set as 1).';
          public          postgres    false    288            �           0    0    COLUMN planetsss.mass    COMMENT     �   COMMENT ON COLUMN public.planetsss.mass IS 'Mass represents the total mass of the star. It is typically measured in terms of solar masses (the mass of the Sun is set as 1 solar mass).';
          public          postgres    false    288            �           0    0    COLUMN planetsss.color    COMMENT     �   COMMENT ON COLUMN public.planetsss.color IS 'In astronomy, the color of a star can provide information about its temperature. The color index can be used to determine a star''s temperature, with cooler stars having higher color index values.';
          public          postgres    false    288            �           0    0    TABLE planetsss    ACL     �   GRANT ALL ON TABLE public.planetsss TO anon;
GRANT ALL ON TABLE public.planetsss TO authenticated;
GRANT ALL ON TABLE public.planetsss TO service_role;
          public          postgres    false    288            =           1259    29174    planetsssSECTORS    TABLE       CREATE TABLE public."planetsssSECTORS" (
    id bigint NOT NULL,
    "planetId" bigint,
    "ownerId" uuid,
    cost double precision,
    metadata text,
    "sectorImage" text,
    images json,
    deposits json,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
 &   DROP TABLE public."planetsssSECTORS";
       public         heap    postgres    false    24            �           0    0    TABLE "planetsssSECTORS"    COMMENT     I   COMMENT ON TABLE public."planetsssSECTORS" IS 'Sectors for each planet';
          public          postgres    false    317            �           0    0 "   COLUMN "planetsssSECTORS".metadata    COMMENT     z   COMMENT ON COLUMN public."planetsssSECTORS".metadata IS 'Will include things like artifacts/content related to deposits';
          public          postgres    false    317            �           0    0    TABLE "planetsssSECTORS"    ACL     �   GRANT ALL ON TABLE public."planetsssSECTORS" TO anon;
GRANT ALL ON TABLE public."planetsssSECTORS" TO authenticated;
GRANT ALL ON TABLE public."planetsssSECTORS" TO service_role;
          public          postgres    false    317            >           1259    29177    planetsssSECTORS_id_seq    SEQUENCE     �   ALTER TABLE public."planetsssSECTORS" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."planetsssSECTORS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    317    24            �           0    0 "   SEQUENCE "planetsssSECTORS_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."planetsssSECTORS_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."planetsssSECTORS_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."planetsssSECTORS_id_seq" TO service_role;
          public          postgres    false    318                       1259    27809    planetsss_id_seq    SEQUENCE     �   ALTER TABLE public.planetsss ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.planetsss_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    288            �           0    0    SEQUENCE planetsss_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.planetsss_id_seq TO anon;
GRANT ALL ON SEQUENCE public.planetsss_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.planetsss_id_seq TO service_role;
          public          postgres    false    287            &           1259    28008    posts_duplicates    TABLE     �   CREATE TABLE public.posts_duplicates (
    id bigint NOT NULL,
    content text,
    author uuid,
    created_at timestamp with time zone DEFAULT now(),
    media json DEFAULT '[]'::json,
    planets2 bigint,
    extended_content text
);
 $   DROP TABLE public.posts_duplicates;
       public         heap    postgres    false    24            �           0    0    COLUMN posts_duplicates.media    COMMENT     ~   COMMENT ON COLUMN public.posts_duplicates.media IS 'By default, just photos uploaded as part of a post/proposal/publication';
          public          postgres    false    294            �           0    0     COLUMN posts_duplicates.planets2    COMMENT     j   COMMENT ON COLUMN public.posts_duplicates.planets2 IS 'Links to the planet that the post is referencing';
          public          postgres    false    294            �           0    0    TABLE posts_duplicates    ACL     �   GRANT ALL ON TABLE public.posts_duplicates TO anon;
GRANT ALL ON TABLE public.posts_duplicates TO authenticated;
GRANT ALL ON TABLE public.posts_duplicates TO service_role;
          public          postgres    false    294            %           1259    28007    posts_duplicate_id_seq    SEQUENCE     �   ALTER TABLE public.posts_duplicates ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.posts_duplicate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    294            �           0    0    SEQUENCE posts_duplicate_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.posts_duplicate_id_seq TO anon;
GRANT ALL ON SEQUENCE public.posts_duplicate_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.posts_duplicate_id_seq TO service_role;
          public          postgres    false    293                       1259    27609 	   posts_old    TABLE     �   CREATE TABLE public.posts_old (
    id bigint NOT NULL,
    content text,
    author uuid,
    created_at timestamp with time zone DEFAULT now(),
    media json DEFAULT '[]'::json,
    planets uuid
);
    DROP TABLE public.posts_old;
       public         heap    postgres    false    24            �           0    0    TABLE posts_old    COMMENT     �   COMMENT ON TABLE public.posts_old IS 'posts on the social graph demo. Precursor to the Proposals (on & off-chain) interaction';
          public          postgres    false    283            �           0    0    COLUMN posts_old.media    COMMENT     w   COMMENT ON COLUMN public.posts_old.media IS 'By default, just photos uploaded as part of a post/proposal/publication';
          public          postgres    false    283            �           0    0    COLUMN posts_old.planets    COMMENT       COMMENT ON COLUMN public.posts_old.planets IS 'Does this post mention a planet? Should be updated to an array based on datapoints in datasets that are hosted on DeSci''s IPFS Nodes>>Orchid. Will be like an additional TIC id metadata tag on Lens publications/proposals';
          public          postgres    false    283            �           0    0    TABLE posts_old    ACL     �   GRANT ALL ON TABLE public.posts_old TO anon;
GRANT ALL ON TABLE public.posts_old TO authenticated;
GRANT ALL ON TABLE public.posts_old TO service_role;
          public          postgres    false    283                       1259    27612    posts_id_seq    SEQUENCE     �   ALTER TABLE public.posts_old ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    283            �           0    0    SEQUENCE posts_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.posts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.posts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.posts_id_seq TO service_role;
          public          postgres    false    284                       1259    27475    profiles    TABLE     v  CREATE TABLE public.profiles (
    id uuid NOT NULL,
    updated_at timestamp with time zone,
    username text,
    full_name text,
    avatar_url text,
    website text,
    address text,
    location text,
    cover text,
    address2 text,
    experience bigint,
    level bigint,
    faction text,
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);
    DROP TABLE public.profiles;
       public         heap    postgres    false    24            �           0    0    COLUMN profiles.cover    COMMENT     l   COMMENT ON COLUMN public.profiles.cover IS 'User''s cover image url (update this to be a url in Supabase)';
          public          postgres    false    281            �           0    0    COLUMN profiles.address2    COMMENT     K   COMMENT ON COLUMN public.profiles.address2 IS 'Debugging for rls address';
          public          postgres    false    281            �           0    0    COLUMN profiles.faction    COMMENT     }   COMMENT ON COLUMN public.profiles.faction IS 'Player faction the user is a member of. Cartographers, Navigators, Guardians';
          public          postgres    false    281            �           0    0    TABLE profiles    ACL     �   GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;
          public          postgres    false    281            !           1259    27933    sce_display_users    VIEW     n  CREATE VIEW public.sce_display_users AS
 SELECT users.id,
    COALESCE((users.raw_user_meta_data ->> 'name'::text), (users.raw_user_meta_data ->> 'full_name'::text), (users.raw_user_meta_data ->> 'user_name'::text)) AS name,
    COALESCE((users.raw_user_meta_data ->> 'avatar_url'::text), (users.raw_user_meta_data ->> 'avatar'::text)) AS avatar
   FROM auth.users;
 $   DROP VIEW public.sce_display_users;
       public          postgres    false    24            �           0    0    TABLE sce_display_users    ACL     �   GRANT ALL ON TABLE public.sce_display_users TO anon;
GRANT ALL ON TABLE public.sce_display_users TO authenticated;
GRANT ALL ON TABLE public.sce_display_users TO service_role;
          public          postgres    false    289            "           1259    27970 
   spaceships    TABLE     �   CREATE TABLE public.spaceships (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    owner uuid,
    name text,
    image text,
    hp bigint,
    speed bigint,
    attack bigint,
    cost double precision
);
    DROP TABLE public.spaceships;
       public         heap    postgres    false    24            �           0    0    TABLE spaceships    COMMENT     <   COMMENT ON TABLE public.spaceships IS 'Vehicles for users';
          public          postgres    false    290            �           0    0    COLUMN spaceships.cost    COMMENT     J   COMMENT ON COLUMN public.spaceships.cost IS 'Cost of the ship in Silfur';
          public          postgres    false    290            �           0    0    TABLE spaceships    ACL     �   GRANT ALL ON TABLE public.spaceships TO anon;
GRANT ALL ON TABLE public.spaceships TO authenticated;
GRANT ALL ON TABLE public.spaceships TO service_role;
          public          postgres    false    290            #           1259    27973    spaceships_id_seq    SEQUENCE     �   ALTER TABLE public.spaceships ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.spaceships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    290            �           0    0    SEQUENCE spaceships_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.spaceships_id_seq TO anon;
GRANT ALL ON SEQUENCE public.spaceships_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.spaceships_id_seq TO service_role;
          public          postgres    false    291            B           1259    29570    starSystems    TABLE     z  CREATE TABLE public."starSystems" (
    id bigint NOT NULL,
    content text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    temperature double precision,
    metallicity double precision,
    luminosity double precision,
    colour double precision,
    "starType" text,
    "distanceFromEarth" double precision,
    galaxy text,
    constellation text
);
 !   DROP TABLE public."starSystems";
       public         heap    postgres    false    24            �           0    0    TABLE "starSystems"    COMMENT     \   COMMENT ON TABLE public."starSystems" IS 'Table for each star/entity that anomalies orbit';
          public          postgres    false    322            �           0    0    TABLE "starSystems"    ACL     �   GRANT ALL ON TABLE public."starSystems" TO anon;
GRANT ALL ON TABLE public."starSystems" TO authenticated;
GRANT ALL ON TABLE public."starSystems" TO service_role;
          public          postgres    false    322            C           1259    29573    starSystems_id_seq    SEQUENCE     �   ALTER TABLE public."starSystems" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."starSystems_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    24    322            �           0    0    SEQUENCE "starSystems_id_seq"    ACL     �   GRANT ALL ON SEQUENCE public."starSystems_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."starSystems_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."starSystems_id_seq" TO service_role;
          public          postgres    false    323            0           1259    28614    votes    TABLE     �   CREATE TABLE public.votes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id bigint,
    user_id uuid,
    vote_type text,
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.votes;
       public         heap    postgres    false    24            �           0    0    TABLE votes    ACL     �   GRANT ALL ON TABLE public.votes TO anon;
GRANT ALL ON TABLE public.votes TO authenticated;
GRANT ALL ON TABLE public.votes TO service_role;
          public          postgres    false    304            d           2604    28249    comments id    DEFAULT     j   ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
 :   ALTER TABLE public.comments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    297    297            i          0    27664    articles 
   TABLE DATA           g   COPY public.articles (id, created_at, title, content, user_id, "classification/tic", tags) FROM stdin;
    public          postgres    false    285   V      �          0    29390    basePlanets 
   TABLE DATA           �   COPY public."basePlanets" (id, content, "ticId", type, radius, mass, density, gravity, "temperatureEq", temperature, smaxis, orbital_period, classification_status, avatar_url, created_at, deepnote) FROM stdin;
    public          postgres    false    320   �]      s          0    28246    comments 
   TABLE DATA           _   COPY public.comments (id, post_id, parent_comment_id, content, author, created_at) FROM stdin;
    public          postgres    false    297   �^                0    29152    contentROVERIMAGES 
   TABLE DATA           u   COPY public."contentROVERIMAGES" (id, created_at, metadata, "imageLink", planet, content, author, media) FROM stdin;
    public          postgres    false    315   �`      u          0    28697    inventoryITEMS 
   TABLE DATA           �   COPY public."inventoryITEMS" (id, name, description, cost, icon_url, "ItemCategory", "parentItem", "itemLevel", "oldAssets") FROM stdin;
    public          postgres    false    305   �d      |          0    29013    inventoryOFSPACESHIP 
   TABLE DATA           _   COPY public."inventoryOFSPACESHIP" (id, inventory_spaceship_id, quantity, item_id) FROM stdin;
    public          postgres    false    312   jg      y          0    28776    inventoryPLANETS 
   TABLE DATA           `   COPY public."inventoryPLANETS" (id, planet_id, owner_id, created_at, modifications) FROM stdin;
    public          postgres    false    309   �g      }          0    29091    inventorySPACESHIPS 
   TABLE DATA           k   COPY public."inventorySPACESHIPS" (id, created_at, owner, spaceship_id, state, current_planet) FROM stdin;
    public          postgres    false    313   �j      {          0    28991    inventorySPACESHIPS2 
   TABLE DATA           l   COPY public."inventorySPACESHIPS2" (id, created_at, owner, spaceship_id, state, current_planet) FROM stdin;
    public          postgres    false    311   k      w          0    28743    inventoryUSERS 
   TABLE DATA           O   COPY public."inventoryUSERS" (id, item, owner, quantity, location) FROM stdin;
    public          postgres    false    307   �k      q          0    28046    lightkurves 
   TABLE DATA           �   COPY public.lightkurves (id, created_at, temperature, content, radius, orbital_period, image, cover, avatar_url, owner, contract) FROM stdin;
    public          postgres    false    295   m      f          0    27561    planets 
   TABLE DATA             COPY public.planets (temperature, date, "ticId", radius, "userId", name, id, cover, avatar_url, contract, "tokenId", "chainId", forks, "forkFrom", posts, articles, datasets, generator, "ownerAddress", multiplier, "isClaimed", "ownerId2", planetss) FROM stdin;
    public          postgres    false    282   En      l          0    27810 	   planetsss 
   TABLE DATA             COPY public.planetsss (id, content, owner, created_at, media, planets, temperature, "ownerAddress", avatar_url, cover, contract, "ticId", orbital_period, radius, deepnote, difficulty, classification_status, metallicity, luminosity, mass, color) FROM stdin;
    public          postgres    false    288   �o      �          0    29174    planetsssSECTORS 
   TABLE DATA           �   COPY public."planetsssSECTORS" (id, "planetId", "ownerId", cost, metadata, "sectorImage", images, deposits, created_at) FROM stdin;
    public          postgres    false    317          p          0    28008    posts_duplicates 
   TABLE DATA           n   COPY public.posts_duplicates (id, content, author, created_at, media, planets2, extended_content) FROM stdin;
    public          postgres    false    294   �       g          0    27609 	   posts_old 
   TABLE DATA           T   COPY public.posts_old (id, content, author, created_at, media, planets) FROM stdin;
    public          postgres    false    283   �3      e          0    27475    profiles 
   TABLE DATA           �   COPY public.profiles (id, updated_at, username, full_name, avatar_url, website, address, location, cover, address2, experience, level, faction) FROM stdin;
    public          postgres    false    281   <      m          0    27970 
   spaceships 
   TABLE DATA           a   COPY public.spaceships (id, created_at, owner, name, image, hp, speed, attack, cost) FROM stdin;
    public          postgres    false    290   kC      �          0    29570    starSystems 
   TABLE DATA           �   COPY public."starSystems" (id, content, created_at, temperature, metallicity, luminosity, colour, "starType", "distanceFromEarth", galaxy, constellation) FROM stdin;
    public          postgres    false    322   �D      t          0    28614    votes 
   TABLE DATA           L   COPY public.votes (id, post_id, user_id, vote_type, created_at) FROM stdin;
    public          postgres    false    304   [E      �           0    0    articles_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.articles_id_seq', 4, true);
          public          postgres    false    286            �           0    0    basePlanets_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."basePlanets_id_seq"', 2, true);
          public          postgres    false    321            �           0    0    comments_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.comments_id_seq', 18, true);
          public          postgres    false    296            �           0    0    contentROVERIMAGES_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."contentROVERIMAGES_id_seq"', 2, true);
          public          postgres    false    316            �           0    0    inventoryITEMS_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."inventoryITEMS_id_seq"', 10, true);
          public          postgres    false    306            �           0    0    inventoryPLANETS_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."inventoryPLANETS_id_seq"', 46, true);
          public          postgres    false    310            �           0    0    inventorySPACESHIPS_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."inventorySPACESHIPS_id_seq"', 7, true);
          public          postgres    false    314            �           0    0    inventoryUSERS_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."inventoryUSERS_id_seq"', 27, true);
          public          postgres    false    308            �           0    0    planetsssSECTORS_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."planetsssSECTORS_id_seq"', 2, true);
          public          postgres    false    318            �           0    0    planetsss_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.planetsss_id_seq', 71, true);
          public          postgres    false    287            �           0    0    posts_duplicate_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.posts_duplicate_id_seq', 79, true);
          public          postgres    false    293            �           0    0    posts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.posts_id_seq', 22, true);
          public          postgres    false    284                        0    0    spaceships_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.spaceships_id_seq', 3, true);
          public          postgres    false    291                       0    0    starSystems_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."starSystems_id_seq"', 2, true);
          public          postgres    false    323            z           2606    27675    articles articles_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.articles DROP CONSTRAINT articles_pkey;
       public            postgres    false    285            �           2606    29401    basePlanets basePlanets_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."basePlanets"
    ADD CONSTRAINT "basePlanets_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."basePlanets" DROP CONSTRAINT "basePlanets_pkey";
       public            postgres    false    320            �           2606    28253    comments comments_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            postgres    false    297            �           2606    29163 *   contentROVERIMAGES contentROVERIMAGES_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."contentROVERIMAGES"
    ADD CONSTRAINT "contentROVERIMAGES_pkey" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."contentROVERIMAGES" DROP CONSTRAINT "contentROVERIMAGES_pkey";
       public            postgres    false    315            �           2606    28707 "   inventoryITEMS inventoryITEMS_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."inventoryITEMS"
    ADD CONSTRAINT "inventoryITEMS_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."inventoryITEMS" DROP CONSTRAINT "inventoryITEMS_pkey";
       public            postgres    false    305            �           2606    28787 &   inventoryPLANETS inventoryPLANETS_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."inventoryPLANETS"
    ADD CONSTRAINT "inventoryPLANETS_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."inventoryPLANETS" DROP CONSTRAINT "inventoryPLANETS_pkey";
       public            postgres    false    309            �           2606    29102 ,   inventorySPACESHIPS inventorySPACESHIPS_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."inventorySPACESHIPS"
    ADD CONSTRAINT "inventorySPACESHIPS_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."inventorySPACESHIPS" DROP CONSTRAINT "inventorySPACESHIPS_pkey";
       public            postgres    false    313            �           2606    28751 "   inventoryUSERS inventoryUSERS_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."inventoryUSERS"
    ADD CONSTRAINT "inventoryUSERS_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."inventoryUSERS" DROP CONSTRAINT "inventoryUSERS_pkey";
       public            postgres    false    307            �           2606    29017 .   inventoryOFSPACESHIP inventoryofspaceship_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."inventoryOFSPACESHIP"
    ADD CONSTRAINT inventoryofspaceship_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."inventoryOFSPACESHIP" DROP CONSTRAINT inventoryofspaceship_pkey;
       public            postgres    false    312            �           2606    28997 -   inventorySPACESHIPS2 inventoryspaceships_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."inventorySPACESHIPS2"
    ADD CONSTRAINT inventoryspaceships_pkey PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public."inventorySPACESHIPS2" DROP CONSTRAINT inventoryspaceships_pkey;
       public            postgres    false    311            �           2606    28053    lightkurves lightkurves_pkey1 
   CONSTRAINT     [   ALTER TABLE ONLY public.lightkurves
    ADD CONSTRAINT lightkurves_pkey1 PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.lightkurves DROP CONSTRAINT lightkurves_pkey1;
       public            postgres    false    295            v           2606    27652    planets planets_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.planets DROP CONSTRAINT planets_pkey;
       public            postgres    false    282            �           2606    29185 &   planetsssSECTORS planetsssSECTORS_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."planetsssSECTORS"
    ADD CONSTRAINT "planetsssSECTORS_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."planetsssSECTORS" DROP CONSTRAINT "planetsssSECTORS_pkey";
       public            postgres    false    317            |           2606    27818    planetsss planetsss_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.planetsss
    ADD CONSTRAINT planetsss_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.planetsss DROP CONSTRAINT planetsss_pkey;
       public            postgres    false    288            �           2606    28016 %   posts_duplicates posts_duplicate_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.posts_duplicates
    ADD CONSTRAINT posts_duplicate_pkey PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.posts_duplicates DROP CONSTRAINT posts_duplicate_pkey;
       public            postgres    false    294            x           2606    27620    posts_old posts_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.posts_old
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.posts_old DROP CONSTRAINT posts_pkey;
       public            postgres    false    283            p           2606    27486    profiles profiles_address_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_address_key UNIQUE (address);
 G   ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_address_key;
       public            postgres    false    281            r           2606    27482    profiles profiles_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_pkey;
       public            postgres    false    281            t           2606    27484    profiles profiles_username_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);
 H   ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_username_key;
       public            postgres    false    281            ~           2606    27981    spaceships spaceships_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.spaceships
    ADD CONSTRAINT spaceships_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.spaceships DROP CONSTRAINT spaceships_pkey;
       public            postgres    false    290            �           2606    29581    starSystems starSystems_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."starSystems"
    ADD CONSTRAINT "starSystems_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."starSystems" DROP CONSTRAINT "starSystems_pkey";
       public            postgres    false    322            �           2606    28622    votes votes_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.votes DROP CONSTRAINT votes_pkey;
       public            postgres    false    304            �           1259    28633    idx_votes_post_id    INDEX     F   CREATE INDEX idx_votes_post_id ON public.votes USING btree (post_id);
 %   DROP INDEX public.idx_votes_post_id;
       public            postgres    false    304            �           2606    27681 )   articles articles_classification/tic_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.articles
    ADD CONSTRAINT "articles_classification/tic_fkey" FOREIGN KEY ("classification/tic") REFERENCES public.posts_old(id);
 U   ALTER TABLE ONLY public.articles DROP CONSTRAINT "articles_classification/tic_fkey";
       public          postgres    false    283    2936    285            �           2606    27676    articles articles_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);
 H   ALTER TABLE ONLY public.articles DROP CONSTRAINT articles_user_id_fkey;
       public          postgres    false    285    2930    281            �           2606    28665    comments comments_author_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_author_fkey FOREIGN KEY (author) REFERENCES public.profiles(id);
 G   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_author_fkey;
       public          postgres    false    2930    297    281            �           2606    28660 (   comments comments_parent_comment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.comments(id);
 R   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_parent_comment_id_fkey;
       public          postgres    false    297    2948    297            �           2606    28655    comments comments_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts_duplicates(id);
 H   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_post_id_fkey;
       public          postgres    false    2944    297    294            �           2606    29169 1   contentROVERIMAGES contentROVERIMAGES_author_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."contentROVERIMAGES"
    ADD CONSTRAINT "contentROVERIMAGES_author_fkey" FOREIGN KEY (author) REFERENCES public.profiles(id);
 _   ALTER TABLE ONLY public."contentROVERIMAGES" DROP CONSTRAINT "contentROVERIMAGES_author_fkey";
       public          postgres    false    315    281    2930            �           2606    29164 1   contentROVERIMAGES contentROVERIMAGES_planet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."contentROVERIMAGES"
    ADD CONSTRAINT "contentROVERIMAGES_planet_fkey" FOREIGN KEY (planet) REFERENCES public."inventoryPLANETS"(id);
 _   ALTER TABLE ONLY public."contentROVERIMAGES" DROP CONSTRAINT "contentROVERIMAGES_planet_fkey";
       public          postgres    false    2957    309    315            �           2606    28828 -   inventoryITEMS inventoryITEMS_parentItem_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryITEMS"
    ADD CONSTRAINT "inventoryITEMS_parentItem_fkey" FOREIGN KEY ("parentItem") REFERENCES public."inventoryITEMS"(id);
 [   ALTER TABLE ONLY public."inventoryITEMS" DROP CONSTRAINT "inventoryITEMS_parentItem_fkey";
       public          postgres    false    2953    305    305            �           2606    29051 E   inventoryOFSPACESHIP inventoryOFSPACESHIP_inventory_spaceship_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryOFSPACESHIP"
    ADD CONSTRAINT "inventoryOFSPACESHIP_inventory_spaceship_id_fkey" FOREIGN KEY (inventory_spaceship_id) REFERENCES public."inventorySPACESHIPS2"(id);
 s   ALTER TABLE ONLY public."inventoryOFSPACESHIP" DROP CONSTRAINT "inventoryOFSPACESHIP_inventory_spaceship_id_fkey";
       public          postgres    false    2959    311    312            �           2606    29056 6   inventoryOFSPACESHIP inventoryOFSPACESHIP_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryOFSPACESHIP"
    ADD CONSTRAINT "inventoryOFSPACESHIP_item_id_fkey" FOREIGN KEY (item_id) REFERENCES public."inventoryITEMS"(id);
 d   ALTER TABLE ONLY public."inventoryOFSPACESHIP" DROP CONSTRAINT "inventoryOFSPACESHIP_item_id_fkey";
       public          postgres    false    305    312    2953            �           2606    28793 /   inventoryPLANETS inventoryPLANETS_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryPLANETS"
    ADD CONSTRAINT "inventoryPLANETS_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES public.profiles(id);
 ]   ALTER TABLE ONLY public."inventoryPLANETS" DROP CONSTRAINT "inventoryPLANETS_owner_id_fkey";
       public          postgres    false    2930    281    309            �           2606    28788 0   inventoryPLANETS inventoryPLANETS_planet_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryPLANETS"
    ADD CONSTRAINT "inventoryPLANETS_planet_id_fkey" FOREIGN KEY (planet_id) REFERENCES public.planetsss(id);
 ^   ALTER TABLE ONLY public."inventoryPLANETS" DROP CONSTRAINT "inventoryPLANETS_planet_id_fkey";
       public          postgres    false    2940    309    288            �           2606    29086 =   inventorySPACESHIPS2 inventorySPACESHIPS2_current_planet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS2"
    ADD CONSTRAINT "inventorySPACESHIPS2_current_planet_fkey" FOREIGN KEY (current_planet) REFERENCES public.planetsss(id);
 k   ALTER TABLE ONLY public."inventorySPACESHIPS2" DROP CONSTRAINT "inventorySPACESHIPS2_current_planet_fkey";
       public          postgres    false    311    2940    288            �           2606    29076 4   inventorySPACESHIPS2 inventorySPACESHIPS2_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS2"
    ADD CONSTRAINT "inventorySPACESHIPS2_owner_fkey" FOREIGN KEY (owner) REFERENCES public.profiles(id);
 b   ALTER TABLE ONLY public."inventorySPACESHIPS2" DROP CONSTRAINT "inventorySPACESHIPS2_owner_fkey";
       public          postgres    false    2930    281    311            �           2606    29081 ;   inventorySPACESHIPS2 inventorySPACESHIPS2_spaceship_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS2"
    ADD CONSTRAINT "inventorySPACESHIPS2_spaceship_id_fkey" FOREIGN KEY (spaceship_id) REFERENCES public.spaceships(id);
 i   ALTER TABLE ONLY public."inventorySPACESHIPS2" DROP CONSTRAINT "inventorySPACESHIPS2_spaceship_id_fkey";
       public          postgres    false    2942    290    311            �           2606    29113 ;   inventorySPACESHIPS inventorySPACESHIPS_current_planet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS"
    ADD CONSTRAINT "inventorySPACESHIPS_current_planet_fkey" FOREIGN KEY (current_planet) REFERENCES public.planetsss(id);
 i   ALTER TABLE ONLY public."inventorySPACESHIPS" DROP CONSTRAINT "inventorySPACESHIPS_current_planet_fkey";
       public          postgres    false    313    2940    288            �           2606    29103 2   inventorySPACESHIPS inventorySPACESHIPS_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS"
    ADD CONSTRAINT "inventorySPACESHIPS_owner_fkey" FOREIGN KEY (owner) REFERENCES public.profiles(id);
 `   ALTER TABLE ONLY public."inventorySPACESHIPS" DROP CONSTRAINT "inventorySPACESHIPS_owner_fkey";
       public          postgres    false    2930    281    313            �           2606    29108 9   inventorySPACESHIPS inventorySPACESHIPS_spaceship_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventorySPACESHIPS"
    ADD CONSTRAINT "inventorySPACESHIPS_spaceship_id_fkey" FOREIGN KEY (spaceship_id) REFERENCES public.spaceships(id);
 g   ALTER TABLE ONLY public."inventorySPACESHIPS" DROP CONSTRAINT "inventorySPACESHIPS_spaceship_id_fkey";
       public          postgres    false    290    2942    313            �           2606    28752 '   inventoryUSERS inventoryUSERS_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryUSERS"
    ADD CONSTRAINT "inventoryUSERS_item_fkey" FOREIGN KEY (item) REFERENCES public."inventoryITEMS"(id);
 U   ALTER TABLE ONLY public."inventoryUSERS" DROP CONSTRAINT "inventoryUSERS_item_fkey";
       public          postgres    false    307    2953    305            �           2606    28802 +   inventoryUSERS inventoryUSERS_location_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryUSERS"
    ADD CONSTRAINT "inventoryUSERS_location_fkey" FOREIGN KEY (location) REFERENCES public."inventoryPLANETS"(id);
 Y   ALTER TABLE ONLY public."inventoryUSERS" DROP CONSTRAINT "inventoryUSERS_location_fkey";
       public          postgres    false    2957    307    309            �           2606    28757 (   inventoryUSERS inventoryUSERS_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."inventoryUSERS"
    ADD CONSTRAINT "inventoryUSERS_owner_fkey" FOREIGN KEY (owner) REFERENCES public.profiles(id);
 V   ALTER TABLE ONLY public."inventoryUSERS" DROP CONSTRAINT "inventoryUSERS_owner_fkey";
       public          postgres    false    2930    307    281            �           2606    28054 "   lightkurves lightkurves_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lightkurves
    ADD CONSTRAINT lightkurves_owner_fkey FOREIGN KEY (owner) REFERENCES public.profiles(username);
 L   ALTER TABLE ONLY public.lightkurves DROP CONSTRAINT lightkurves_owner_fkey;
       public          postgres    false    281    295    2932            �           2606    27686    planets planets_forkFrom_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.planets
    ADD CONSTRAINT "planets_forkFrom_fkey" FOREIGN KEY ("forkFrom") REFERENCES public.planets(id);
 I   ALTER TABLE ONLY public.planets DROP CONSTRAINT "planets_forkFrom_fkey";
       public          postgres    false    282    2934    282            �           2606    27716 !   planets planets_ownerAddress_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.planets
    ADD CONSTRAINT "planets_ownerAddress_fkey" FOREIGN KEY ("ownerAddress") REFERENCES public.profiles(address);
 M   ALTER TABLE ONLY public.planets DROP CONSTRAINT "planets_ownerAddress_fkey";
       public          postgres    false    281    2928    282            �           2606    27604    planets planets_userId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.planets
    ADD CONSTRAINT "planets_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.profiles(username);
 G   ALTER TABLE ONLY public.planets DROP CONSTRAINT "planets_userId_fkey";
       public          postgres    false    281    2932    282            �           2606    29191 .   planetsssSECTORS planetsssSECTORS_ownerId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."planetsssSECTORS"
    ADD CONSTRAINT "planetsssSECTORS_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public.profiles(id);
 \   ALTER TABLE ONLY public."planetsssSECTORS" DROP CONSTRAINT "planetsssSECTORS_ownerId_fkey";
       public          postgres    false    281    317    2930            �           2606    29186 /   planetsssSECTORS planetsssSECTORS_planetId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."planetsssSECTORS"
    ADD CONSTRAINT "planetsssSECTORS_planetId_fkey" FOREIGN KEY ("planetId") REFERENCES public."inventoryPLANETS"(id);
 ]   ALTER TABLE ONLY public."planetsssSECTORS" DROP CONSTRAINT "planetsssSECTORS_planetId_fkey";
       public          postgres    false    317    309    2957            �           2606    27840 %   planetsss planetsss_ownerAddress_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.planetsss
    ADD CONSTRAINT "planetsss_ownerAddress_fkey" FOREIGN KEY ("ownerAddress") REFERENCES public.profiles(address);
 Q   ALTER TABLE ONLY public.planetsss DROP CONSTRAINT "planetsss_ownerAddress_fkey";
       public          postgres    false    288    2928    281            �           2606    27835    planetsss planetsss_owner_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.planetsss
    ADD CONSTRAINT planetsss_owner_fkey FOREIGN KEY (owner) REFERENCES public.profiles(id);
 H   ALTER TABLE ONLY public.planetsss DROP CONSTRAINT planetsss_owner_fkey;
       public          postgres    false    281    2930    288            �           2606    27819     planetsss planetsss_planets_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.planetsss
    ADD CONSTRAINT planetsss_planets_fkey FOREIGN KEY (planets) REFERENCES public.planets(id);
 J   ALTER TABLE ONLY public.planetsss DROP CONSTRAINT planetsss_planets_fkey;
       public          postgres    false    288    2934    282            �           2606    28551 -   posts_duplicates posts_duplicates_author_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts_duplicates
    ADD CONSTRAINT posts_duplicates_author_fkey FOREIGN KEY (author) REFERENCES public.profiles(id);
 W   ALTER TABLE ONLY public.posts_duplicates DROP CONSTRAINT posts_duplicates_author_fkey;
       public          postgres    false    2930    281    294            �           2606    28833 /   posts_duplicates posts_duplicates_planets2_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts_duplicates
    ADD CONSTRAINT posts_duplicates_planets2_fkey FOREIGN KEY (planets2) REFERENCES public.planetsss(id);
 Y   ALTER TABLE ONLY public.posts_duplicates DROP CONSTRAINT posts_duplicates_planets2_fkey;
       public          postgres    false    2940    288    294            �           2606    28230    posts_old posts_old_author_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts_old
    ADD CONSTRAINT posts_old_author_fkey FOREIGN KEY (author) REFERENCES public.profiles(id);
 I   ALTER TABLE ONLY public.posts_old DROP CONSTRAINT posts_old_author_fkey;
       public          postgres    false    281    283    2930            �           2606    28235     posts_old posts_old_planets_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts_old
    ADD CONSTRAINT posts_old_planets_fkey FOREIGN KEY (planets) REFERENCES public.planets(id);
 J   ALTER TABLE ONLY public.posts_old DROP CONSTRAINT posts_old_planets_fkey;
       public          postgres    false    2934    282    283            �           2606    27487    profiles profiles_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_id_fkey;
       public          postgres    false    281            �           2606    27982     spaceships spaceships_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.spaceships
    ADD CONSTRAINT spaceships_owner_fkey FOREIGN KEY (owner) REFERENCES public.profiles(id);
 J   ALTER TABLE ONLY public.spaceships DROP CONSTRAINT spaceships_owner_fkey;
       public          postgres    false    290    281    2930            �           2606    28623    votes votes_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts_duplicates(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.votes DROP CONSTRAINT votes_post_id_fkey;
       public          postgres    false    294    2944    304            �           2606    28628    votes votes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.votes DROP CONSTRAINT votes_user_id_fkey;
       public          postgres    false    304    2930    281            c           3256    27649 0   profiles Allow users to update their own profile    POLICY     v   CREATE POLICY "Allow users to update their own profile" ON public.profiles FOR UPDATE USING (true) WITH CHECK (true);
 J   DROP POLICY "Allow users to update their own profile" ON public.profiles;
       public          postgres    false    281            _           3256    27773 #   planets Any user can create planets    POLICY     \   CREATE POLICY "Any user can create planets" ON public.planets FOR INSERT WITH CHECK (true);
 =   DROP POLICY "Any user can create planets" ON public.planets;
       public          postgres    false    282            `           3256    27621 #   posts_old Any user can create posts    POLICY     m   CREATE POLICY "Any user can create posts" ON public.posts_old FOR INSERT WITH CHECK ((author = auth.uid()));
 =   DROP POLICY "Any user can create posts" ON public.posts_old;
       public          postgres    false    283    283            ^           3256    27772     planets Anyone can see all posts    POLICY     T   CREATE POLICY "Anyone can see all posts" ON public.planets FOR SELECT USING (true);
 :   DROP POLICY "Anyone can see all posts" ON public.planets;
       public          postgres    false    282            a           3256    27622 "   posts_old Anyone can see all posts    POLICY     V   CREATE POLICY "Anyone can see all posts" ON public.posts_old FOR SELECT USING (true);
 <   DROP POLICY "Anyone can see all posts" ON public.posts_old;
       public          postgres    false    283            b           3256    27628 %   profiles Anyone can view all profiles    POLICY     Y   CREATE POLICY "Anyone can view all profiles" ON public.profiles FOR SELECT USING (true);
 ?   DROP POLICY "Anyone can view all profiles" ON public.profiles;
       public          postgres    false    281            \           3256    27492 2   profiles Public profiles are viewable by everyone.    POLICY     f   CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
 L   DROP POLICY "Public profiles are viewable by everyone." ON public.profiles;
       public          postgres    false    281            ]           3256    27493 ,   profiles Users can insert their own profile.    POLICY     r   CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));
 F   DROP POLICY "Users can insert their own profile." ON public.profiles;
       public          postgres    false    281    281            Z           0    29390    basePlanets    ROW SECURITY     ;   ALTER TABLE public."basePlanets" ENABLE ROW LEVEL SECURITY;          public          postgres    false    320            X           0    27561    planets    ROW SECURITY     5   ALTER TABLE public.planets ENABLE ROW LEVEL SECURITY;          public          postgres    false    282            Y           0    27609 	   posts_old    ROW SECURITY     7   ALTER TABLE public.posts_old ENABLE ROW LEVEL SECURITY;          public          postgres    false    283            W           0    27475    profiles    ROW SECURITY     6   ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;          public          postgres    false    281            [           0    29570    starSystems    ROW SECURITY     ;   ALTER TABLE public."starSystems" ENABLE ROW LEVEL SECURITY;          public          postgres    false    322            �	           826    27415     DEFAULT PRIVILEGES FOR SEQUENCES    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;
          public          postgres    false    24            �	           826    27416     DEFAULT PRIVILEGES FOR SEQUENCES    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;
          public          supabase_admin    false    24            �	           826    27417     DEFAULT PRIVILEGES FOR FUNCTIONS    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;
          public          postgres    false    24            �	           826    27418     DEFAULT PRIVILEGES FOR FUNCTIONS    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;
          public          supabase_admin    false    24            �	           826    27419    DEFAULT PRIVILEGES FOR TABLES    DEFAULT ACL     y  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;
          public          postgres    false    24            �	           826    27420    DEFAULT PRIVILEGES FOR TABLES    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;
          public          supabase_admin    false    24            i   �  x��W�n#�}���� ���Ûn� ^�{A8�y�Q���!�Ꙟt��K�yɓ��/ɩ�&��$@ "�}�:uΩ���b�XNf��bI�˛����Z����n6;z�����5�&TC�uG��I�n��v�yeX���Tj������(�5mtI�5xF�w�<+U����N���U&�uG���J����G��?�y��u�}��N�5��Tѹ�%E0QO9��$D?Tq�zr�xr��˪�W�>?��/��˦��>�������
�k햪�{z�j�CT]m��=i�%kZ�Y����Q~L�'-��</E^�*�XR���!DR��m���M�*�E�0M��k���Hp�U��	�Ӡ���߾�����NAl֦Z� ���:Ȋ��j��� �3m]=X}F���*;������A�W�t�
��2z�7�� �*�f���}n\�mȱ��{U���I~��~�Og�4����V8���Πi!.�8��V+T���+g���8�6@�W>�k�T3ң7{D�#jՖ�
�空Ng���--�#*�s�,j��b�k�F)L��Ԝ������g`�gL�?� Aɣ=G���j{�5�3@;<��[�Y�Pǵ�'�B����Y�LE��[��5z�����i5����o�%��
`g���U�r�7���V�Bկ!\`��
b�]Ҿ��НĢ(����C~�������/�EA�1k��Fz����Ƀ ��Ei���|;�� L��!%�\�^�z��L�N����g/�f%ۓX�)�e�_b�"�W�zk*�xI�i +��R;���IG4�b5��bK�B�6�37q�%��������z䅕�%0�t
H
�U��6@��1q�����d�p:\-���� �p��� _���c�;���gy�Z���
ahS�{�A��b��N�,� �|�4i���$��+p��ށ*e�1�:Q=�PП�d8�L�R��|j�(��!�֬2̐�{J�s�i���J���\Hk��O� $����žF�-Q���&�9Iv�:}m����Ve�	
 2G�()s|oA�X�(��{��-�nP��O��@�E�-c��Bإ@��k�{L�F�����k���1U:��"s������~���	 (�
��u�	J���;�A�&��_�r�PZ��rB���3S�q(�fR���_1�:9I�7֝��Ye��?���[Z>/h���|>L�/����}�Zr��P�C� ��/��.�B���e�P7�x�~��/�Sj� �,��wD��>hoR#�8��z���[gͪ�
W P�اW3�[�b�HY��_�,ShaP�V�l?���z���!SS��U^�ɪmh�U�t�;0{�?�J5-�-�H��Дv�L��Me�����c� )������đ�Wr�)#��6��@�*s+s	�+;W>��Q�˺�R�I}����E���˫fr=k��릹8�/��~ar��nh�BPB�ј����sJ��6���bY,�/.2�;����_�'�V���V}t���g+N1-Ӗ�ɵ2��Q�y9��ޡ�?ʃ��Nw��
@e�}S`_��]Z:-�+��E��~~�2�Z.��?K�e|��.}�^��u��k��r6�DL�Wi�f&����n���V�>��=����*��dM�b��9������)E�����{ގTy.���"5�Jw�v�iwj�yߨ*��)�<v�8DV<��^�%�v~N����}��/���lv1�!l�1�>��4$$���9�5m;$҂�Sp�٣IJs���Uͷ��P��ZF����Vzi.�o(S]D�{��)O�RH�5�|S�'�d��`�s����o��n
����?�ē�ٳ�Fؓ]Q����pw�P���<      �   �   x�uν��0 ��}��(���Iӝ!q�1��S�*���Vw#��e}�2O����`��s�I��9���\���Y[S �� �-�0��
j����z���~���$xOىj�T���Q;��_�}�^	���Xj{��yr+�O�4�T��k�{[jB,��S0;��u͚�E�'����>�      s   h  x��S=o�0��_q[Z42DI�dm�d��,�P��b��EU����F&��a�&��}�H�.y{I^{3}$�(���6$
[�*����]Z��"m��K�+��v��'y�iV�B@�5١�/Y��Z$O+��/���k����3����h�CS$�D����@o/!V]��I}�L��=X$'3����5",&�z��c�f$���#8KoB+����l�#�s��t��N��(C@o�u�qD�=�6��(���S���[x~�L̹H�#��3(i�&���B'*8?1i�#�9�b���I��l�W�%a�9>�܈IT���V\��[x&���uQV�e �ȷ�q0a���鈾#���h㥨�d��i���vڻ$�uX�EQ�j�Ң.i�>ԩD�O�C�r��nگC�TI��|��c8��MZc-���˱�On6`�>�g4~~�)�����G2��uW5a��J צ|��\��`��2]�w���˨�T���ooᛱ*�8�	9R1=���k��V�u����h>ߞV�T��/.�_L�1�gR���~��&Y0��#���2�ӟ�4�h��:�H��{(�m7��oȺ[         �  x��V]s�6}&�B�k1�dۼQ>��@2&����h�-�c1������v $���L?x�wW{tv��A��!�!@��N�hԱ�]�����	 �(�6�kb�F�� x�,F�,}:c)U�"|��pj/���+Cu���nH�ۻ��})_��6�a�d��.�	�O@���PV���r�lBD���S)碩�3��zB�O���SL��ҥ��	}��u]diH}�+R:���)+R}��`z�����%ɝ6\[���6�d�:CEB;B���� "CX�e>)�VM�T�Ԏ����wQ��u�P�[�
�i�Mc�Q2�΍����
��:Ԡ�p!$��ȝԗ��5���Jʦ���m�JV��d�K���K��D�i����<2����֤�P�v�ĻWu]g�x>��f�~��9z9"�u�s������&|�H0��̀_&'���,�n�[�R�I��
h�O ��@����#o�����Ց ^4��2h?|1�B��?p>;a��pD�z����\��!��P���S|E�i Z��8�?op���c*�u[�6�=CAڿ��6�'���c�so�d*�މi���{���=�Ԙ>4�U��ߴ�����pw�8P����ۮW4bp�!��T��q5���rp�?��@���髧V��K$��3Z	�f��?"�1y��CuIŴ*�)[	���"B}���a�fR��
H��Ov�g���)����i�mlء����NZfШ</�44�nBTG��:�;i�n��FZ"���IKEjG{$w��66-��ZN�Bh"l�����Q�s�C���������JK�[ZZ��p9K˳�܏q��gi��,-����*-�&]�K�^� �%,�(DH�����b{�����-U��$j`9��<�0f �&@��H�	uj`�I0�Bƫ|q�V�c%�������\�̳      u   �  x��T�j�@}^Œ���^K�|	�⸗���������&�uweǄ�{g׹PR�}Р�f��93��ݠWh�H��[����Ɲ	Q���
4�ۘMo���^��ȒTd�~C?��(��)��e����	gu�I�b��d/s�(��X�$M&1��I���!���6�5��}�ދ�e1d��uW张g��-���W�Ke=K����hC?�D�%�~���=�y��;O�,��8y�8b�
���yk����8��1���[�1�S(;!�\z��AQ��h+�a�t��d�,�+����'\y:���3i�!��U����wqZ�G� b�h��Ҕ�,�TY�ፖ�c���(_�yd�P#u�JZ��"ט�����ݡh�\�BH�\\�-%�݋K���<����k<�}���}��6+*E�j*c���)��%hp6�~b{�Ndʃ޵���FZ,�n鱁=�$��:Y��J���Pqj���|����],+4: �`�S�.B�=�!kM�J��[t��"���9Ƨ	[�7^}���ց��G��_³yOd��-�QR�Z9�r���v���w�k��Pc[�k�K�[8*��D`~�[C��P�V���8�'��	�pU6ݟ�u�"�Ő��R���cg��t:���      |      x������ � �      y   �  x���;�-7D�ULnH�_������_����lÉ[/n����*
7��y�YvJWݟ$zp:�<���T�G岍�8AMT���ƖI�
�����6��(���Բ�1��xSxO�Fָ�*�s(���Y��3q�@U�i�wK�����z��*�8!�������]*)$��@�&�r�@Y��3&��i�*�'�@	��Nrܜ��������D8�(��jȕQlȎ�Ū8�)V�$�^b�C�A�1H1�����ir.��mRޣ�Œ�+3�9��� :Yҝ��
�)�
u��(�N���6����QY+��-��a-|������������8�e�E�4��Ҕ�n�K�h�n*\˻�X�!�HDl4t�X�-���t���5Kyd(�[���_�j��rE+>��^7+,i�{|i$y������Z����ϖח�,酃�`���Y��+,o�G�YT��,��5+��W}�c���X(��4�������/bu���'�f(uڞ���+K��ZA��^ƊL��h
�&z���r�sf<X����/�2Y����l���{G[e�?���؈#�EV��l�4k�?u�� f.�5X��Ү=*�z՜�K���H"x����9�Ƈ���_�}ӔC���da��
K>��F��S�+,��	�ס����]��C����my����,�g��%�).�{}�k�+�'��Ҹ�b}���BLd].�&��J�C�_����/���y      }   �   x���;n�0�Z:��`	��C�nDR��"�l���43X\(C.�r�V�k��������6�o#�	����O�<�bN�a-���V��V�"D�-|Z���-G��l)��_/�OL>�R3W�D�J��3�t��!%`�7.�i븏���;&
լI�d��fc6�@s�Vl��N~$��#�d�h�ъ�S+D}wc4�az4��v�����C��U9	��\����{Z��H�z�      {   L   x����0 ��=d�B�`�|R��#���Ոo?87��r2�z�^e(�:�<M�i%�r�ֈ�;�B��/D� �      w   +  x����m!E�3�8�?�M��l���H��7+�t|t}-W�bzF��QgpnzYL}-��^?߷�g2��p�Mw�0��ւF��uh��lw�be� �T�m�]�iOi���w#n|eĈaP;�D�ѡiXV�H��c���̘ >F��I�������,��m8�5�����\��Yڃ��^�{�|�����_�m���J*G��?��DCeV�i�+���q-��p�����_�˅{�! M�j�zP�?����V#�� 3D0�W�]����փ�˾��	��o;��������qʶ      q     x����J1���Sx�$�d����U��B���Gj��,����m������9�����^�z���E�Í�Qe�Pd�R�� ��*�~���b�R��M��'c_�Q��`�כ4�@���j0�-��f`��2xljtJy��=�Y����c���m��~;|Gxݤ��bC�"�@#����Pl��jy��6�ۼ���c����r�PK����3�>8a(.���^X�Dt��S�ګ���a��9�Nz��_&��n5'��8��%�+�"���g�N�eY�,s��      f   �  x��R���0��ϸ^|����]�I�:��S�-��(Y��>��"H!`��`wvwv)���'��8[j�;�C^p�r�ʐK�!��	��T�[��qbׁzH�*O�ا/]g3��/��Kl����^�<��1���FP4goG�O��-��懄�t;~��(&�a&�4&�
���N�v����'�YA��YL�ؕ�` �*���W��|?8�U�.���Ş�UA9�oB)�*��0��\��	9S��2:ׄ?�e�h�bЬd�*O��(J�te~�nJ�T��ң���}H�u��h����0�v�L�������v	-s��o�F�hXwM��x�K���NN��O�y���Ǿѝ/�8F�
=���6�����s�	\����m�F�w�e�
��7      l      x���g��ښ&������O6�*�t���Y"� �")����s��^�s��1��it���
�
ox���$�f�����a��@��'��~'�8�b
!�o����G��~]��C���X�a���=^�=�*�ʺo�5m~���ќ�Lzx^�)�d���}\e�kܔ	<4Q�-3L"p��]�G鯑�,[��u�����g�eC�/ߡ[8&�Dc�G�����`0���`,�YL�i�$!4B��HF�	�0N�d�F��E�YLyʒ�Pq�(I�QL�B�����O��W�@C+�?S���y�.��_�B��i��d�����B��	�w�Ib(��*ƒ�fP��W4��.�,-����φ�3l����a���6��%��<��?��@�mE�)�d�Q��Ȅ ��fP��	2O"���I����(�24�"
V ֹd�P�7'Z֩�S��]�[��iBG؏����?b��0H�cL��DJ�=���w�����@q�'�+�ž�?��X~����,]a')�.�`n^�~��-(�>߳���r�Q~��(����@~��o�E?�Q.h�_Q��<�	�.��Oj�
D!i�#������-����?��o�����B`���P.��[D1���*&����C�?�f���Y&�����	E'��I��!)���B��,�f(J22�#<�!γFb�D�,#21F&��_mv�i�]4G??�OQ��p�,����H7}<�٩�I+�M/�n.c߻L�B�N�k��n<�H�t/�2��^k��CP�4��f������e� 3�`M�����c&�(�$�a"��b6�res�;�sm�7��--硟˥��ZvM��
�{������
����g���G�/�~���'R8����?���A�
c����F���1em�e���0e[���Ap��鏝��A�� Z���P���_I�h�7��oQİ�~b��$"��!� �?���\���aF�oS�ߚ�QA���?���
����I�&YDg�!	��R�!Ҙ��," ���� ��'Ia���(�7׼�	\��D����8 K�w�%�;EQ����S��{
��.��?tԡ�^����/J�(BS���� ]$� %��?� �b�,��hr #�g$�O�(�P��9�&,�3��p@��c1J�8K4A�4�+x�9���t�4���`?���� T��= 5~" ��O0�/$��;I��O�?f�0����~28�R�_2��"K�E�1��S]C�$���\N����wk�`���X��D�������G�J�ˮ��/ۯ�iΖ>��_�߇I�-Y��%3�l������~���Z�����I�� Л��_%�B�� ~�~ �O(1ap&J�,Gs"g�('#2#H�ӈ��%F���_�π@2$�, �)����߀4�����0��8P�w�T�w���\�x��k��G�!�NR���8��l�7=��߀�d�4�~�	����L�?�XB��b������kv0�w���<��C��v���_�7�������?�M!(E�:�'��R��D��2�D<�0��Q<A�@����o��8�`�6�S,Ќ�O�C���&���(�/`���A]S��#�0���R:(�K�<�G������Q�?�A�����x��M���g8�Bz}���	�Ʉ�����v����lٿ�n�� ��>y��;��H�4��6Ig1F\������n6��t�q��?^�h�3<�ot�;��w?��#� ߬�S�-*�;E�j��g���Yp�м��������\�6?���ϗ��3�g���76�����"�����y��ޗ����v�KZC�R;�]-
D|�s}:�U����I�Plv.~e1�m��_H�pu���r�:*���H�R��:����������Q�gQ�k��Gc�^/
���G��R}�SB�>'����x�������_���w���ܧ5�g8��5������
���J!�}F�Ui���.��u���Y�ȇ�A���gD�cͥ��c���5���[؞���,��G��ݽI�����P�p����R�r瀲�9b�g��]�����}o�v?��v��q��K��Wܤ�3�T7޺��7��ϡ�5�S���F���[uɰ����xOo�� Ǩ-Ŧ,D��P�P𨹥ܯ����u��%�` �Sa�'�x���h��n=%\��9�C��B���5G��Rj����ڍT�'��:�w�'��,��'��+v���9�H�%���ɩu�u3F%�ò����*6�olTn��yw��du��m���$+Ҭ�"��a	`B�.��'�Cq/p�ƛ�=@l�z�����8g���J�QS��@^���}�~ӎt��q��b3�8I:gZg��c�$�'o�-��w�z���[^㧭�������(\!�,��9���?���L��˞��r�ʺM�&�0|3f<���砷n �i�)Pv7����a�=HA����]J�9��}��m��Ĭ��t'��N6�I��|=��UIP(���f�~ �<��Dc���<9��m�0L�^�nē�P�IH\b�j{��s�,Us���%�z>�q����mc0v�|y
/�hDhQϏg��m�H�2vS�7�:�`B"�y5�Ԩ�S��;?MS�h.vۉ��L>��f7M�� "o�v�j)NW�I����iJ��{[�^kH���D��:&�
�Cj�Z�F������ٲ� �����,Ќ���/y���#3�;�<���Ú[��?6��Q�`��ɱ�,3%y�W\��$���X`�������df�UW�ǵ҇�bo=3o�L�Q�Yr �֛� m��^�<�<��Ԭdy8�
J�ʨ�3/^$��޾T5�js�g���ă�d��n2ENty�w ;�^S�:�LMU.V�%ϷZ��箲?���,+y����BԨ��N��r�TW"�(��"ȟe��$Ҡ\��� �fvb+ξu;�[�o�2��l`���eg��֣>��_O�Y_�6Mq��+Y��|b�?��h��_��X6͛+ي�Ȏ(���x^�եߞ�g.z�,~�<j6A��[Iử�I�J��@c�Nȸ��v�\m�c]���)���Y��@�] qTPlL��5�,ff���۪�!>ꙓ�)�-�b���F�Kb#
b���.��8�P�D��8����X�b����cGe�:��n�.Y��*"H�I�N�YeV��M0��m��=u΢0CW�ꢴV��;��yL�b授ʐ�_�#�<�K6_w箐�?�K��hZV9d�B�33�)��9N��#��q��eÞ�d��`�i6_�p�C(.%|Se��ӳ(����L�A��>� �J��2X��w'����?bM�e}5w�ӄq�(\��Qu��rg�-�ŧ�p_h�����ǧ�Uk�����l	5��lw_;c�&&h�p+�áj�;�&m �Uq�A{֡»ጁx����ĸ��2T���YV���#����O�P#���"�X)7
Խ��Xl6|�0���;�iZ+OZc��r�������4(��Ŏhy���9PC�i�gZ7�������q�-ߺF>�p��8~�n�֘
*yb��u+h���}<^��b�Od`�^|���	��˶u�B����r�x�D#%�J�B/��v`���[z�{r�
 ��MIS�8��(A�on������uítq���t(�̸� @U�^�����_�Ϳ�7ɗ��p@���T�NJ�޹HB��4��~vD�LjF�!� ����l��,p)��&o����p(;V�3h��ְ�=kRH\pL�Z���Kл��c=L
c��� �!���mw�h��w����c��I��}ck�x� ���p�W ��ls���G!8oJ"�N@F�- �C��ED�����f��(ͦ�&��(zPC8Q�`�-��i��&)��{s��B�Ϸ0��T�d?/��_]�;z�v�����    �2��'RU2�����t?�F��=�� ��=2�5��u�\jv6��H��c��-̣#3 ��M��I��R"�����.���W�z�Ԡd�E�0���y�9�R��͋ ��珍`2˦@/�b]#p�K�� K?[�A�~B|9Q��j�jT�h5�	tޠϳ󓂃���<�G��r��7i� +�@ g,NR�e��$i�g�v�1	Ly��8s�ʷ���w"� ��W�;xN�4��GjRq�VQ��Q%��&���GU��3@��3���%(|l����[�N�ZX�P2��<P� �)(�����]}>Q���a�x�&L������[�� E�%�_�?5��4��>A�Y�m�X�eQ<� ��7γ
2�X�t�k���yx�� ��$��|֫W8����l���1pS�2�ҋ��E�����cG2B�=�8�;.��k!����wQ~Ϸ��l�d(-���1�)��������8P�m�fT(��f��5�P�kUp��UB��O�� YK��ʮ ��W
���@� K4�B��+P��0g������G
T@A�7�\�"��G�Τ�D��R�D�)J�m��p0؜+G��J^&Hő_<q 	 sۧBG2-�$ː�Q@I���,�Q��W���@]��o�b�I�$��3��q�5h�A�~�*D��r�p��^��2*��j�[0��{���U����m}��c�P6��. ���/ߓ»��<���=�'� $��cz� �t6!��~�'s:��\O~�Xx�8�|)��x�_�f�(� � :�>�"��o ���ˊ}W��I�lj����[���G�h������ E����2��b|@{̮*g.�Mk������ҍo�	-���|���	��=�@,��=c�
4-�q����}�aƠi���E<�o!(���=��C?P�m��a�D�U&@�w/ޙ�݄A#��H$���ӱ��綧�(�yOV��
�ڼ4�>����Mz���������30*�p���?�^w��C�����0b�;1~>5����t��sb�/���`�g�C5ѩ��	N��Qe��I�קF�z�!=����0/�_{�O�޵�)1������F���C[\��P�S-�V�����������#;�S��������gH��H�m$��̓p%�e@?��N����,M��4�k��\u��G����Q����D�u�9���vD�^p/߭:�y.hx DNiA�/�����Y�����O#���.�Y�rq%0��6����$$>�<� ���n@îG
�ٷw	�v�1)��%~B}�h�� �~}eݨ����K>I� ��y�Ӳ`W�wba�4
�	��x��7VA,1c�KdQ[.�Ϲo�t�;���E��o�4C6������.8�.yp�b�*%��?X�q� �y�P���x��L��k6�'د�FQG�C}�yG@�b��;�?@y��5z4{fK4zζ	T]�b?]bرDQ�*H'H�v��v�U��&H�e��I@L��X���bL
�"�=Yζ/.��//���a$����;8Ւ�c�kj8ֲ�<�I4���Ch�z7C#�\��SI����Y h�i��ҭ�e�q^øM��cv�� n��$�~~0�B�i�������Z{]X�So�P�Dasx�g����ѵ|}�y�@MS��7x���CQT~�BW�Ƞ�5M>��3i�<|o���2�6|�ϯs��M�]F�@�3NA-МR����6W>?�:����T,s��P�s�_�S�=�5TnM��=3b�뺀~,�Zc5����$௒X�z����%ÇU�\�r���(��=��JK� (�Q���Ic�����{��7�^�w�'ж:@;�jE��Po#-V)�n�\ryp��~�E�=�lL���A_ã�9��w�`���w
$�<"�Dߞ�{ �(�lN��D�2-/���/_��E_�ڗ\�&�;ěX����G��dr��T���0.����ꑗ,۽�(���,G�xF��M�zs��jBc����SB1NucD;�D璤��v ���Uz���]e'�CaՔ ������*�Q�CֽvL�� k��]T?F�=?Q]�2��]���t���x�o���z�)��S��L�j�S�B�=����u���A<�v�U��q[縎�Bh��>�f��s k��
�X��G��+�#�nghvf���sy<Q�\�۷�y����8y#. ������d�:��~	2 t�D�Z�Q��nV0��.���,�� �=���C/�O�SO���_Kj�j�o�����VHj��s]�j�P��ð,ϛ ^�� �O�)��4F�����+��vY���:��}y�=1�;���^&K�iޣ�4����w�G#qq�qw�蓦��+zI�U�䟳�<���hֲ��
�<�/*��M��Lхj�.%Y�-{�m�\�H�ở����p�®p$��NX��gT)�����y��/l�]�����D.�{=�9*�qB�@�p����B\�x\�=��޹}�]��	*����F��(_���cH�&�`n�C�V� ~|��Q�`C]�WQ[|����oj����+��G��r��¼^���uwk,6J*'���5�_vV{��j]g<�;�K{x��O�H������`YD�%�>�R�k�ס<{Y���%/>�^(-(���]���u�	;|�r���#���Q�/l�Y1��\���!�eVL�����aHi��t��=9`.W�܀��c?��~�YkO��:~���~�K�y�Y��pnEAR�r���bHdԙ̓��Hx�=a�WD<�����nE��Ja������(�T��L�� �����?x���h��ۣ���Ҡ"y-h%{�,�q6�v4k��1FSu3��S�nW���%�P���(z�װ�oEho�����B`߶\��ۖN(���t�g:�}�����:MLp���w��[��n�B�|=^���n1Y�H		�N�o�%A�L��ީ�ތ���9>�d��G�FV��U��zH_X�(�'��QpBݫz7���|��:�m�1ޅr˺�����7/7�SQ��qaa}R�@(��S�Ϸ�����V1�W6��}��£�ߍ������������"��E��< �i��ij��\��#��L�>��3+Va�$�*���B���E���f��vm����Ba��5�U�E�C���	Bi���Ob�Ҵ<
!�&�p���D��	X��ZO֯�Owz�C�n_	������-���������\�����(��G]����4��"�=<"p�%����i�銢[���n[�,��>�/xGܰ���]��ddj���y����L��������Z;�(�A�����|9��Q����%�-�4/�SJ��a0ܘu��@�{�OP�:9�Z����~�^��g� \ew�Jk4��><��Gm�je�S�-�r�&�5<O.�l|�=���A���F|�v"��@h+�Xn��?�D���yd����$�=(LS����b-��,o%��W�܍#u7����Ĭ��}���)CΝ>�B[�]��R�z�~4�ͣ�h
�(ɇ�Y���;��Bq+Z�U�
��O���h�_�+����ɍ���}�W5h;-��Dl�`�	��fW哩�ԧ��'v_IY�=m*��(H�T��Vi�!����q�C�PG�}��z��$���g�#���2�k=tfcT�D�_��0��&����	_?�M+d�b7Ov�^������$V������ Yɺ8��y�ߛe-Z���73�&����wϥ���x��X�2��#��m��B4ZГ�'rb�~���U�U���MW���#u`��+�p8ubx-���H�Y!b��������>��?/�Ud)���z"w�����<�Z%��?jn�%�e���O�)��&�Z-qd�A)��S;�'zv۽�u�ZY|��<iW>��>��0�ˏX 7]�f�,�o��ޝ�
���	�ʹ    f����Y��R����ުG��W��Ö*�5TľL�H B�	P�,=�	x	����GM���K�ܛK0��-�^R�e�^aa����v�6fqr��0��0
�+}}gޙb5.�V��V�f�Y��Z���k�Z�D��Qj�_��z�Ǹ;��%�4?���oUw��d��r��?#���m��R������H�|\�Ճ�^�l����EW{~�D�&U��ʏQN�;�Q�|>���y ���:TF����<c�����E�έ��{�h�w䅮f�ۢ{�6�o�1e��|�����6B)����-��1Uzu��+&"a{���-�.d١�[�$���*f���'��V��5��4�|�
b�W�l�C^cֽg��쒎�s����v�s):ZǬ�.��B�M��<
��fm}7�W������q��I��O��@Lriuȑ�-�H4���x�`�����ԹC.JIY�"E�n����i{�-����S���QS��!��a���=r�\��6�_���O������u'Ƶh��!��v5�y��KF�|�4�ރ^'Wx�P���� k��;-�������n��k	0��ƜϸD ��ME,{�ظ����_���_���U\g^�r�2�:�� �mq[M��!G0�XS)`1U=�4�u!����㺝�m����zq9ݙYѭ}+�*n����}��k����!(k�+to%����ؽ��������텷:.������[������~S=`�
B[}	��xa���_�OȆ\\R�U�떥��׆(�L�^�x��p���)FҠaLy�7����n�C'�59�3����G/��U��?�ཙ��ò�Y�G�>R�|�9��i�����pd	��:�P��ReTf{�I1��/�ǡA<�"��CNIAג7�����4�H\���sd�:9�_<a���q�=(_Y���A�q�nm�Kc1��pYg�\R<Pʖ3I���@	s��+�+������QRLuυug�,`�wR�f���~$��y^��s�`7���1���\Z����:��W�2��g�x���1�L�E<-��lhH8X��y6|����ݛ|FK��<�c�䛶�3��C��F�C������V�>�4��K�[=�j�E��Y&�p���6:V3�xgs�WϽ}�&̠��������.��i��q��iߛыQ���CM��n[������� �ի�^�Ư�d^�$L��I�]�b��4ѯ(��'�ܡ[�`�&��Mk@J=nP�����&���%aD�tjW��rj��t˷ʔ����S_4� Iܾ�)��Et����;��E�ь�g],D����=g{ƞ��5��Σ���AeDO�Aa?��9Ľ6�����]�4h%t\��Ɲr/��� ˸�Љ�/�B��Q�6F�����6����*+�r��RH�;nh5�`B &�P�>p�nw���|#Np��Ñ6�������Gl�\�4P�!Ī�ļ��oL�z��{1#����qn���"����e�1Lp�4�^�N�V8̊�n�`�[|X���_�;'�b�������փ�q�a�yQ,���tBc����N�����X'LL����48�y~jһd�0�wx�Pq�Xl0�Y�t�����:z�ύR qx�9�������m���Q��M�QD�@ct04k���Yk"F2�y!��o��qa�YI�[TJ�����!|K=��-�H�+.��T(�e��?�	�T'�k�4� "�@I�K����86�;�D��Z�����W��%�e�T��<���_]l��� &�K8�P1q��Ɣ@P�#��)���k�$h�)Fꗟ�e�-�<��~X����SJ-�㘿-��j��X>��7�@��'�yͥ�����Sr%��'5���.+�X�+PUu�u>�H��y!�<���%��R�l�5mc0�����)>�͡H�c(�����U���cAa����Fåg0�xD�UV�8]a原䠉т��s���?/4�	��깫"#�� ����U���O����-��<�|��s��!�u퟇ݜG���a�Ƨe��S�bV��\�}&���'�{��6�D,5L� K	�x�u�X��:����ӕ!!��O)�0�J�r`���:�Φ�.=�?�s|��5e/�q�������-3}1�VŎ�$�=g��ܑ���Rs�������*,e�_G�Э@K+=�9��vX�IF�kl(�>�ފϘ��2������d��Lڨ�rK�857���s��,۪�����f�x�����:�1���[���芎4�;ԤTm�e��#����b�u�.��Ρq7/CE�N�#1P�"����y@�R�vby���t1u}U�I���N=H���R���wi�eޏ!�����>�x���Tkp@�3��Eë�*�c�K�Y
���tM-�X��sѧN���}5�b+3TZCZw$c�M�x@�Sz���&�VQ��Ic�Ɋ4\ㅏ�T�z|?�X=�5i��M� ����6�|]��"1�u�QL[{I�7�����ޱ�S��h7�
�{C�<��B^w_η�]�������J��y�[�{߉��7��Ι6��$I���G�����h�|r5&�1z������u��){�Ҩ��:[v(�;��l�s/iZ�P�̥xNP��<5YW�`�zw���
ؓ�)K9W� &�-�i��P�>���dV�h.��N(IS=�%������}���� Ò�j���VT��4���o�=F�/C�ޗ
��ș\�ݍ|�ב����:�?��x{k("L�D����AD�� 1�#���gq��P���b��+k���Ɛ�vQf�6�m����<����Ŗ��j�piT5b(�*���׹�0��O�ŋ=�7_{qB͍��b&��>�G��l/�y��s�_E�!��m;K�O܅��C��`�̸�Q:��	�믛闤�)������Di�}�yne�gj�T�+/�u[�gP�k�['����c�����#�g'Qeb��s卆)�(44��C<�n>di��Y��BmS��������t?�ɚ��@P4kL�ey�����F��[����Y���c8�L���CYG�i"�ɑ�,����*u]�A�Jr�w2��Fk�Ai_���,���ｈyO!W��JP�����e���t����t_��Q�x�(�5���5j:�O�z����]n�E�+��-^�(Ɉ���Qy��)}S�d�������ǧP^�t�Y�Vj��l�=�(k�Ƈ��9&��V
,����ál����O�>�Ҁ�`\_y����73�B.vr�H��m8�"�W6UJ�}��XA� M�	͌�SDM���[�7h � ��u0:�9�SɈw�C�lc�֊`�\b��vY<Uzܞ��r4���v�$TSf�b����Y���������v�1�+<���`b�v�<r����/{J�~!�ڶD$U��5�����ІX���'���.6Y����A������n@��E��4��(MS�g���'�t���H�̬Pɋ�k�5��o�����)q�����oԥ�leZ��.���]��8˜v�ȵ/�Z�	kNoc���w~
�j�ɝ�p���Kv孳�C��gn}y�u^~ğΠ�����]�[�M:���1�'���!L�)�l�]uth;6�bv{vO�փ �Z��Jkg����8��9��ޙ��?�W�{�^���^G�߱-�H���̵�"4yv��T7���SD �J��V�@ʩP2֠����@/����o \��KJ��=S�o;=i���%�G�W�^�����#�0��^&zۻ�9�^�0��>�8Ot�x�FP�l�|`p���BB0���g�:�SS�3D!T���/�����M(u٧�Ẍ́�U]��P݈�=�\���ʄ�OJ
�4�H���Si(��L�&���0���8�Wx�P	M�ʚV/��%+߼�:�����<���g�zf��0��q�W;ᩦ��JÐ�4;��j�zo?z��|o	5L������    Z�#��O9�����t�P]���0�2^=ºN3����H�i�1�w�~���?[�>U\��"h,�-wt�hH��0�eu�5%�8�WD}�����*��/��z� �����a$'z?�j��σ��'�0�)0�7����iqV�:��E�d��2�yO1ŒG�h���q�ג�����	e�Y<�0d�4k�(��n��_��c�M��AXs �a3��l�-|�œ�q� ��pG�����n����>>�[�fT��E��}k�9���6B�`~`t�ڍ�H���p��y���:L��	�x�}o�g��� �`l��$?y{���O�SN�k�0�2)��^i�\�9�����W��C.�CO��5�A{OA^�ա�"Ё�����7g��q9+B�"�Â0&�؆1[W���d���Wn������VI̄^Vј�}��������|)�gb�}H؄1��Lq�+؀o�]�뽔��I�n�|'����WE�Va|$�����=������NG㼠U؊֨��x7��#�6+�!J�}�r�����료�`�xWr�s{�<t�`�mu���s
cR�r�l��T:&S����E0o23��{Uv�e�&._?����3�-oE�����8J�����l
�����({՝���1��G�\�dp9�Զ<�����q�!$�֝���J�����tt��=�8P߷d
]�w}���l�X�����=��|F��G��ӎŖ�2�̕g���<�����;�;���KG(��\(�WŘ7LD%x��l3Qy���{>��Dm�g�5��hZu���xIc��WfT�6gm�uuX\'R>��C,vO�>���q�u�p$-��A����QB"��ZA�7���>�+�:�ɢ%<��M�%��B#J����x4Ɩ�x�n�(�Lu�?;x ����	5�x<
ɐ��6	����>���i@��FAL_v:��g����ӭ^;�Kڝ�V��f鏿ջ��X�����#��	��?���yf����^�CA�Z�ŷ��V�v�X��8�8aڵ�}�̬oK74���k�<�s�/�������s��o�:��+1d�t�g���{�D�*�X?���%�Q��}x������9$�{�C�c����zTx��Q�i�K�3w�F�Ј��\�'O'Ƚ+b�"|�|���̂�А��+R�|����;��CoF)A�i'1�`a��w��XP9'�V�����G�&G����	o`�;?���|���@}�di/���I�G���.ڝ��_���4`L�k������|x��×����wlU|L΂�8Zߪ�G?Q��9h���[��W H ���y��	��{��N�����J7D�3�������o�-��&Q���A�ƀ�m�F=Nbk������w�xe����p�UBI0A���~ʰ�ґ���C���J�s�tV1µge����-4ig��j}5��ֈ����{���c�'E���N��� t�/x{�d��df;�敠�f~��Ҡ��V�2�>P�6]��N~sT���"�(��q`��W�:c����/cױ�(�,?���#��a���������9�4BP�U��=�w޵�JQ� �4Ӈ�ď��P��HJ��2|�5#}��R����P��/?>N���ݐ�+��V���1�D�#`�+�kG���?ԯX�-����!���-�H� w� �8қ}��ʞ�!��kH�}�t�.�2�qf����#��O����IV5�i�q��/��n���WA���ĿK@�y��ZGH�0�S ������@�D���Uw�E���F����}���<b�Uo���,M6aQ�덐�`J�(p��՛!�x��c�b���-�N��pvD�{xYlj�7/�J+�������Aa�j���drrʰ��j&֜v��������/����{~~�{Pe���L�/��ސ�\�<�����'���d�������XFz�}lx����@´��6Eih�d2�wHM��~0�Qi�g;hA��	Y����T�Ϙ�CvA�fx���bnۨ�O��-xy@NX�\�MT�&���i�F��|����d����*��@V�=�	�Z�f ��&�a�*��=�Q�p��]40���+N(ܖ���{=�#7 rT�,G��#�s1��5���d��l_{�����l�ɗ��O�h�HQ��R��������wX��$�>�Iw�i~T��v8W�k ���K���gNp1�(z�\��(N�U!��?�'��rO�ZPn�M.�9<�*4�m9|���NَT��2:K!��
�ם�~���������������^�+ ��{��������`��*E��Z�a3�8�uOuD�e���z�V��=m��F���o�ӄ��a�F��qr��S8�]~�e���U}b��B�3}:�.�&��(،X��L�ј���MYy�Ho�������z�9��_��#�l�����L�x=U��f�O�$�`.o��!\j�S �I�����GI.3͕Y�4�Q<L\��pFA�=	w�|�u��Ug���	,�4��˶�4GYJ�l��1�>*gN���Y��k�R����Y�9���D��VE� ��m�D��0��`��eS�X��]�I�5p5Ξ�ټ]����!�*�{�1u�}�WN4�Gh�� 
�/���~G���!�xH@��_><<�W�W~C'�kM3�v�����@�he����J��"����(d�e�V�*��\4�S�`[  ��s��T>��o����w�D��yMA��6YGQ3UI��ξ��>ª������!\�����9���~9���5 IG�Ep(4��͸堅^!d��E_jEI*�#b&3��մE���dj��d{�2~8T�z�)���ȯ����xx��&�a��6��H��FZ��7N~��䄥6�����ZO���"���1=t�:�M0��b��5���p�*Ot����ˤ�]�h�6��
"d��+���x��N���}��A�{~J2
<�ٖ5�q&>��|`/��o�� E��P�Ѿ��ވ/PO˻��m"����߽����'?��D�3��`�g�%F	o������F�����6 ��<�O��+	ԢZn*��L��*�XR��3~A[C/O����Ey`�� ��j�~��s�7��u�J8@����$+�~k�������Pf��4�^3�Q�5�
x��JL�]��l���\�m���,�8�8��bd�A� ����s�����Ƥ��'�:��.�Ŧf�����MI���^�y��T^El^�&mJVr�-(����Ùߺ���~�᫲�-�39JԆ��&R�e�q��@P���d�;��������uU>��J,��]	�\��	��ƀXH��8=4D������-5j���o����C�c
��+��"1h�,��0��I�`�6&�c@qs��6�vL�pi Q�$U�u8R�?�R:�K��<7钜/�Gn3�Q�_Y{�^�>w��-Hv�K�OD冒�2pm7@��"��)�����Q7����T��|�2���>��ӓ�42��	!(!�4l��++-�(#���/�j]*���Z�D�����U�뒚G��m��Et��h��6�&B����;�|��i2L �:�/�A�Y-�c�o=�>���urQ�]2�ȟ/ٞl�邛���4��۔�j�O�S�ϜD3|�o�{z�.'�zu!�n��+e\ sߕ�G�d�%b�@N@X�E*Sx�@{��\�Z�@�vG�� �D�a� ��q��)�|�WN���I�\��0E��s����V�������)��p��묇�~K�XPU���U1|o�_��d��x��+�A~�p��ycL���Kp�y����Lh�.+~�
����Z�Х���q}=�%q�fX|�r����:�!5z-������ɉ�\�@� <!���{r'})z��F�s��g�ى>�8&u{�30x0�m.�����V9[n�1�9�?2��࿽/�    �g��@<�^�s��L[��bFC[zM�9+�
C��;@t_����x�%U�9ލ~fΛL���jr�Z
J�����u����Iv�\��2z�:AnpMz�����Q�}�� S1;�0~�s��f���BC;�6k�U��*k�f��r�&7�{C߭���֍� �s���{���C-P��g�q�D%��S��>�[dS�1�{�zg,e�{�5�LVZE�Q��\yN���A?mR�j2��d�z��Jh�d=BT�(FWMd{_��B�?���W��[	nB���K:(��N#��F�2�B-��q�C���f���]3,I��I���k_������(��&�D발U��"*r�sk�ȫV0<��(�4�xX��zxc���N�� d^�Pe�S�a�r�O�1-�&3�S����K��V���N�Nz1�7�y?x��w� 5!��Y�X�d{~Q��E��#M*zh}��]�_��n��!��N�E�ke���x���B�T�c��0�(�������Ux�sْ8ϓ#P�w6.��'����a�{Ek3�|
��I��N�K���Xn����8���/���:E�Qq�I^��+���~������#��8�������J�;�Z���q�z��=�M3������<,6�O�ۺ��A�T�'���1�>�S�U�j����i�D��x\fp +]:��Y*V�Y7�C�7O���I�T���쥣���S�&G�m8��3&zy)��(�E�OP׵�ݣ˕���0m���X��l+�}/\�mR�ێC���r0�v��?���Z�]9O�|sH�q<��Z��m ��<ɷ�ǋ> �^o{1�!��hl/nJ��S�z�d������H�6��1�@W�3i�k����t]A�*i�.�j-�3�9�{ė&��mS�L��C�Լ��4`�sTx��=y8�1���bQB��c�L�qt�6w�	yC/3�\���w~fM9.r�MZ����ikk~��E<������!�����e2��f\e�(�G�a��}��X��n'.#f��V'_��r��WJ;)��p��ơi �B��ʜ�caƛ��0y���-G��t���jVz�R�fTcc��n)����:�+L��S����zZ:A���샮]�G�@�Y�%|m�ek.��F��p�Z�Z��/�!�&�������<S�-l��V���^��f��`�����{o8�J�*��=*�A�T!)���J5���E�7ڿ���@���������E0e� �)�(H-	�PR�E���@������{>j�k_ �¤�������.�Չ���+$#�T$K���Rknc1�.�А���H�QY���\�OM�ӛ�V��t�
c�/��z�t߹�Ӈ|�9�y���|>ɬ�>����re�x�s}#�:֓��k�˺�fK�覒}���J�����}6?uM����Z��9am�g�;a"���E*�Fv���*�n�����b��	eq�w�G��Gf0�o)��M���j����8�9s���>N��2�y�#����1q�~��3�k'�bQ�1^(��`�S+ې���m5����Z�fu_4��`@ ���MK��ٓ��KD�
�|�޾Kj���P�Q��}�y��OkHՀ�#a7�:�\�b��rsX,z�ڵ�%���ٍ�\ �B�Z��e�ü��3b7\�� �[;�MXhwl�vO�;-Y�/��i�KR�W}�������Vȁ��	Ȇ<g����j���lsv�X&�_���+�u�#��y�w"�+��3,~jUd���<��ݠc��+��."��o����׿��'hjU�Z��(E�(���{�r��nzo����"l��R#���i�ߎ_a׸~"7�q����!���f���`���@��\O����we��2��!����j|ôGP��%\T��c�N=���)Gϸ��h
ǜ��#ơ^�֚��6]#j/�
լ�W(Qo�>%[�Σ,��ENh& ��-�s6s�@��8�(�>6���AHx��i�F	s�Y2�6nI���9��������K�I�#����H`"�X��ޫ&w1d�r>�8�w�b�=R�av�h N����H 56�+G!�����SNbmJ0��5���yYפ����9q7����Z�T�;��i�Y�7�.�%/��=��ĢԈ�Q#����46���\�w��u�`L�Ͽ9���� H�M�����D�9��5��f��
���V�1���C����2�
]EV4�U���I������F���ɋ�I�F�&$rm�܇���^Kј�����o��2�|����Y�ݹ:�ѩ|��� �2zY]�{�'����z.�%�Yh�hJN�V�	�6<N�MN[}j$ՃO�p�wW�����]��|��QbP����4ԭ�G���-U�/Ҥ]�g�g��G���o-+ÿɘ�L�P�)�	Aj����QvⓄOx���O����i���ק�փ�ޜ���6��=�����d����巡J&kh)Gロ�Y�������e��o1�n6��[��	,ßI��Y)��_���������5�����M����Ƴ�V^�e��k��i�:�����!k{��(I��=a���$\m2">�����\���t+�>�X�v`��dy|���o�4����a����r�ҙE%f�:#/[>K&O�sX;_��inG����5^��V��mJ��g�G���5@KJ�ĨI�YW>�",� eߥ�2K̃UM|���\�o���`�^�N$t�-^�`�_KD�҉��`&fG�W*� ����}"s��Lt�:D��#k�[��W�Q	;�X��&���|�5*�B��̟�ܭ/w�pN@�����8��c��왔�ޘ%�{�~|}j��+�����Lj �������"�����#ܩ���PA�i'n ���	VI����  A@p�İ�1�����#�M����~��e�" � �-IB��M���Hj�S \�m��r����9�P<WÉ���4��ɃI�͗�y�+Ն���9�pe��z��x�牺j��L@��"07��1H����1q��O)-16Ý� �}i����B��d��eo�?A�8�I�{ҝx@ʢ�`����{ϓ?�� -�b^��ZK���[_p��T(�	)���Z��6,���o�W��y�-�?7�M����^y�s:����d��z_�(�as~�Z���[���Ya�<��/��M~��pn,n���Ϸ���E���q%um��l^K��9;}��QT�S6�l������h�C8��v�Tl���Xk��G�خ�BY���#A%z����Ԡ�]>�1�~�\���I �b����!�hXMNr�9.[v�}��ð����Hojs|�|��E���xԆZ��寷�Nf2�0y�}�_�1�����'�jz���ͣd{>A��
ی�?NJ���O��Η?,����p+��bv	�/��GלLVv}ƣ�⤒�m[��(�ڶ�D�����<6��֏p�U8����ń������K]���'���CA�6��S�)�ި=/3��=��x�6�O�Z�xa�k�X�H U�ظP=5!�v\3���������s�d�W���������fc�1��A����7����ᄣl��|�v��8( Ԯ��n����.�ǂ����I��Ă~�X��?�;�5Gz��x#���"�����|��%�1�"�5|+�(Ύ��(�IWzdf��RJ��?���_)83�x|���ŀVi,
��kK�7M�"S�����Qի�ݘK�i��R)[Z!��;���ߞR?"~�jT�i�?2��
=�7Ԅ���1�j�e�_���˓Y�l.aFRH;����h�L���=
ޣW��%u>��s�v�E�{\ <,�K���6МX|���ڨj_���5�6�����8m�z厔u�BvnD%�� ���
���6~�h��`�L��1��[Z��$J7O
��=�<����F��1��g�D��|���B�붃b�*I+W�bPN��T45��i����Z    �~m}1�'7�'"���TI����D2�����'�Z���S�Ê�����-����������yN��>��;���ި�X
eo�Kj81���v?X��p��#<�6��=z�`V���=g��hܙ,�}��C������w_T��H���������N��@�u�CL����h�t�'|��
A
־�Z7������`lx"�l��ə���p�v+E ���6aC�h5�0fuV��@�=�o_���1�� �.5N�d-�#�z�j�����(M�+��=וKw��v:����sK_��*2o�ȶ�,�Z�p�p8�C��9�E{Q�G���>2eR*��^U��,�T���'܃dA�O�o���%�Hc�)��.l6����ʌyx8�)T�(��2L�6ӿ-T_�wD ��bWu��������cGj�tlpQ�'t]E��_.�V�����	��r�+�y�I���a�c��FH�n�wG{4�*��Ьȶ�Bj f�vi������7�� �xS�M�p;�+�&�Rh��Xǃ;�ZVh}u-u���[���� ���N{gy����`�k�00�11,fK�03.��U[wբ�A7��� ѝ�L�$�X�9f����[��g��BL!˦HTD����󵿻կ��*L������[`��`�]�-#x?yڜ���ڙG�~08�8`�_e����xArC�v���y���uL\�5��s��2_��D�T�H�Md������x�=������a�Q{o=���&6��O�7!ts!�}F�`�^�畄:u�=��y�_�	���=mvy��G�z�F��c�ԉGP���
��d	}�L����5W��C���.s��1b'2&!A�K��X�:b��"��|L�|W��/��::s~�Z��`I&�O�|�s�2J'vo���+��L���.�$1J�`�?3y������\�g}�e�n۬��4�%C �
[�|1�R{x���B;�����Z�tP"^��H6����A˅~j��Fa��g���{f]�2b�h\�&W~� �e �9,�U�,���D��WpQf�X�/r����QcO�I#��C_mxE�?Ӹ�.M�#�7(p��GȰ����A���W����א��&��8�l�k^��iU��.�U�7�^)��<R��������3��W��B����/��3�P�3�'y"�������{ tLÕ̘�h�5Z����ߤm�ͤ�4VH�J�C/�(ȼ�	�-���x{]�lMڳ6N$]c�y��y8y9�S��x{�HV#+"��F��A�,�<�n�a�"d�G�4�!�&@��3ص#��`��Q��b���o�� �� �&�'�dE�̻l#����0&ײ�g�J�ąrj��|� ��C���.��X(�n�`��jT������p��Hd�(P���t<%��5����'��I��J�J_Z(�`w���՗�+R�J���
jo';G�P�)��p�vR�]�����<c+��Y[�_��{26��^>EJ�{?�̑���T^���ђw�����j�[��"\��<^��E��̗�� �������^�� �S���1���E�m�_���G���(�7���2���-D�t�Ҍ�T�'����\��F#��AQδ��S��a�:ݳ}o�s	�f�e)�p��TQ���o�_=U�Ԩ-��.m����i���!��^�����x�ҥ��f��ԣ~C+��x�nhBѳ�0z�����"�i�(�΅�~���C���B{i���ŋ1�c؞�eB�3��J
�5��4BJ����S�6�i.��sg��n��'܋�I;˚�ۗ�H��[#���;h{x��v&^����C�͜ I��)�\J�c�(���� �qh��ZX����~�)�>0��hߐ�YK�� �6*� w$,B8,hj��ϘŘ)����$�6�ʲN�е�W0�5CT&G��̖��<
*l!��>��ZP���g@7�(�6���>�{U�:�+?O� ���ɢճ��̷'�ߪW�*b8�J�ӏ����a��M�,���a�H�v&�B����llV�* S�{�Y9 ,0�]o7T!��Q�Mɒ~�<�&���2�5s�:��$�P����M�j����A�����n3f^��(Q�ږG=5ץٕ&����ڧ
�7'���J��B��H��>��7m����5,�5�O����h�b���<�=����BG�z�m#&-�[����Pȭ��Ơ�����6������Gyn:����!��q@a�(l�^�x��R��(�\^�5�@Q�8nj2>�j�2�.8���U�-�A�X	R��E�!=����="m�˪�9<�1e�]�<��� G�ύ����]��R�wL��gb�-�������㈰ HF�s�	͏tHLT��f�XD���"��D��kkceM�䝑�g�~8�ԫ ع��yNy�GTeC���z�J���)m\d�K���[�f����/��-�Cߥ����%h>	�D=<�Ѭ�������h��8U~*�]��U�����[L㛲���N�ÁnfÀ���#�,����;���>�����`����7�)�4�Ǝ3^0ݰ���6fH���jߏN�IO����|�6C��2�,�n�))�ੌ��sg��5'�k۫{!���y�Y�	�'�s0��\rŢ�?����u���(E����=��-�Ͷb��D�m�Lq|�og��}$�a ��(h�'�V�d�3EU=�i-�%�Z<�ۻY�&���`���*P�i.GPL���C��>sD�(��0�n�!*<xb}�;3�����}ӷav�ȭa�T��b�]d��S�rx�v�t �g�grX[�z꼂��]�w�P��?ZE19����Z |e-W�.:�#Y8�c��HԾɶ#Xr�vk���	+9X�u��!���$Z7e�
�3-�"صY�<l�/�$�װ�ZC>�uH��\���M�\������C�~���b��Kr���HB_�j�qʫ�z�	J������a!Z�Ib?��sDaN6���]��<�꟤�G�6r��� �;����;U6:��}���s�+¤U~L ���=T7���w���R�pc�#	iM������1*E[y������"l���RT��l�(���M58)r����7x"dg*�DQ�0���P��P��X��MI��B6nʯ��"�V�b�3q�����1$�G۱��K��6�p���a�,��8v��8�V0)$�(�O�0�)��i���d6�i(����.H�J�ssY�QllvLS*/��u4��M��ʿ�����^Z���J���`jXJ����9Q��f�m'oW�R'7
7_PZH�Ļd#���Y�8��Y��	f�lܻ)�Rq���ñ���D�t�#mһ&�
B�_�c"��ϫT|��H#�v����R��×4"}��9oJ?A@�%n�w�����f�9����v�E�v�D�r���pQ2���|�K��;!Jd�:}���d^o#��8I�W��O�XQm�'��I�P�r���k��)���Ηk�[ytAɖv�u��#A�WO�d|ڣ��T��xA�<�L����h	��	> x�.�d��GB���-C��D?��~%��0#U�gp;FH��=���C��]�.�C�H�D�3ì� ����p����� ��K�2V�æo����E�k����X���$ E�n�Kn�NR����v&���6�'���efxOߒj�X����xr��F��. s-����Б��YI���K[�
~c��ʐ)+r����&m�n�QH�LPɜh0��k`�+�v_��r�ͬ=Н�z@�٠����R�����}�ۯ0CƵB��t/�|�XP[���i~6�5CJ`_n�q��U��#qvcĖ�n�{(Ax�9e�=��������g1�`��AqW@�}��+��
}���Y[��uw|����F67+������EA什f	��    ���
C�k��I;,���b�'���IA�&h�j�Kr}W�
�<�Z��_Q�4D ��������<�{��u�髯���]$йa�}�� yR�c��s<yYRo?������'�I��)�)�~�������z��|���Q�q��F�~�ݪdYC~���1�\�~��8�;�6O%/�x*�f���0DݽQ�T�NUJ%)��>���g��P����j�?��?/%P|���V�?�Iܳ�-(5�ʽ��kO����~�qlM��O} :	<wt���ct����T�_����޸hB���;wd�FB���Z�x�y�Z��8����OtѨkA�"y>�� M�X�u�t�4�r~��X�m���g��_&�I�n�d���z���{��`�f>�ǟ�b	��\�	`POS�?J\O:l}�A'F'�i��@$ovV�����k�ǫ#gN#�l₥d
�r�F��w���f'������a_����Wɟ��ϛ}�����o���?��h���7fߏ�H���-2�����u��!19�7���O�� I�Ě��d�Gy8��=?Oh�I�͟/�o�C���B�
�v�M��u�q��!HAM[y9ԧl��Eܓk}�	��(��ۇ1�"�~���^��u!4�%:C��z����ro>�ھ��֢F#�z@����Y�\D�F<>�kH������J��>�B��ac��QWt��yYe�~m8Y��Ҿ�I�и��!�Ջ9
sl��Ƿr"���J���o����_J�4��/�S²��_?,*7%�s��̑چވ��bL�i�u��>
�Dh ��b��Ǒ��g�h��qS��q���&A��Asۛ�^�k�?�'1!A����Y�Qc����E�rj�W���mC�d]��V3�;\\d�?o?܃�cI�s�Q�&��srk�QapD\H���j�t`����0Q�hK�������q��MCo��9L�}�������"*��fϩ[�R+lS$�2��`-��k)���gɂ=*�N��g?�r�1��jT��-m�<���fDA�K�t2���'q��	��V�� X����J�vD��<,�;�#;渗�A
���t>"�r���EQ�۶��b��
O�\���kS�(��������<,ċ�N�T� X	�����IsF?�)�ϩ*��^�V�~�m�G��Ŀ�х�m����ߟo��̪`�ֽ�����	Ht�A\�h���$�xp���y��g��j����_���.�9#����>+��|�\�<��aP��⻲8H�2�!U�8<���0�{�����|?��ܑD�r~�k�#��ǙQ�����4?�M�f���?�SI�A�&C��GU��\I�R@L֘�8�/~����o�{voon�;�[�\Dgtۋ�>���(As��ȟ��o,e���v���V��_���R������#���ΗX�����6�i���y(�O�At��W�9II^.�O��Brb���$�F<������g�|�(
(�IM��F�5���y���+�#�����σ	����I?K�u�
�W�����z��S��M=�?iH�Of佳��?�j��% U���q|C��ٕ�	�<�+Q!d�>r�)�R��(�<�O�9v�����?��a=T[���k�k xb�-L�#<��y
��|A������������"�?��ū �M��g<��ږ�l��I.i�{��9�p?�����vym+�=�1ư0L��:^}|�$���wcI�i��@L!4~�7/O���N���T�������.܌���AH����w�Y2����i��I*�=Y���x�C25�$�ġ���f>ߋ�+\dT]���h���$�0F���|=�����ϩZ'������
�
��.M�\���+-�o}��$�̷���她�8]����N�)��?��b�F�-�R)��^/�V�C����+��͛�v�ߟ���B�,M%�-��PS�� ��_�����P�����'PO�K`���D;5�G�??��N3�ܟ�l���U��-�wy�d3�ݔv�7"j]�>�^�]/@�m[�d�y�Dnmz�8�8h{�L�����Ԅ;��*0Y�x��{�0&�h-�.��w�IkE�ؑ!�C���~��|�R���
����s<�ba��� 1"΋Ԙ�8s\�ep�ꃠ_�|/���NF?Q"���)�y��q?y����$�%A0��Lv���W��J���y�s/ł��Κ٧��%�_?��~�O�kD��o��c���7lr�����MY��g�=|И���p7��'b,ŉ�C�7=t�~rc�R�-yQ��肈�Փ�l�����������#�R2ђ�o'_!ɇ���m�-�8� Hx�5@��x<�2����6,_�3G��̋���{���Y����@���o�r���_�(��ꓚ[!~[��x��dE����r,�����j¿1�ݧ�������W�D8��h|؇�>>�}����q��8T��U3 �k����hF��П�ٟ7����g��:L�m��BꤐU��a�*n0)g�|��bif�������*���C����z�@�B�a6U�\C����O����q�p��%���>���G�j��&��A��ޯ�f��8n�T.�h�W�)���y�Ќ����SO.�+���n-�0NDIV����P��%��<�}ieZԏk�����T}����@Kn�z]��s�9>�R�1�Q�0�y��` �m���Mw^U�4��y��[�K橤T�y����3�ؘ�\}G��w�2�����Hgo��X���я�t&�}�Z�H�CV�M��P�0]�t�t���9ZF�Bh�՗5�@Ι}��k���zp8w�bz�3�c��4�
K1��U��[u�o�@���6b�ͽ
�ezE�2YQ��9�s�f<ƀ&uU���g�%e�$����^HY<��Dc�mh֏ZB�D :#��t@ָ�C>�/�4٢����H����4$xGp�^�u���<����f�< :�  20�qQ�;!H���H����+�����%v{�4�#�=^��ު�H�!�S�0��S�����aϓg�@g����9�8WS}l& ���r��u��x*�9F�O��0_�@�>pF9���� �3��"@Q��K���?�f �*�G��B���!a� 㽴��	�5��RD`�-��}��-�2��yc��r��V�CЁ���1a�~���]�Ϯ@'s�{�)�=����z�TR\���ql!�!�q���?���Ma�A�3��=����;~߻9���~�Ņ�{@���!u��]qi�4YP8G=�{����=���D&�.�V�ղ��瓀�iatC�|��h8�36�e�lߓ9�Ĳ����z�&v����e8T�9y5�t�W��`);����!M��˰@���jm@|-�S��3I�#]"y��Z΃�ɝ���p$w���sX��Y��)��.� �B�9���`�ʻS��v�6�U�3��?~�������?�U���?X�� H��D�CI�L�Y#�)�o��Mx��p��C4��L���_soE)�f���7w�Q� ��(�t���G�=��Z|� #�~��$Uέ]�z|��g&�u��ȧ<��>P���s�����غ��S��{8�<��b���=zs>k���"����S�,-����FP�����3���+G<�CX�6�� L^N|c*��	���X��Py�|�$�K�R>ݣN��0O=;v�E ���Flh�k��y4��s}��!
��ZO�u��m9�4��p����Y��igW������5|{]����)E�����Y��g:&����I��3�S�s���P�8| �.m��z3�}�3�-`[a�+9/����̟��W
�oֹƆ"W�c^t3�T!��]��U��0��m���iS���bn�u�M��$����-��1.�s���ZO�o>�j }��@ѥ�2W��P�	��sq�@�W���#뼯QF�S�ǉE�������(��    '��5��Ϻ�y�P#I�񜣾Q��������7�hؓE�����6���($�k����^�BǷnr��������y�G�4w����m}}aD�
Ox��,rJG���)��زj�~�����{�"�F��\�M`S�1�Y�H���s`JF�n�0}sX	���?��o�N���w"h��0(2��g���&v�G�{j>��l�ʡd�w_�2�m��y�ǖ����rVp�ꕲ�nv�������9'�t��8T�k������f���N�p���� ;��|g��W�21/�~�W����k�p��Xz�*n+I��1���\�������Ů����}m-|ܲd�:o�n����O��e���lU[8/�x��ٴm^�R9x�0��~W��V���)�a|�3��(�$�����_:�7�����.�N��]��%��g���?��E�5�tݢ7S��G�X� #:�s8�_>:rf�-����`1����X\F3���/�E� fbf�w�����>��{~.T�Ʒ,Ԛd�?��.2�v{�5��<_\%Z��+:^�~��Yl�bK����������v�ths�o�uO�'��ey�(^��d�މ��-5J��ʹfp?����<ψfY����s��X��ϵ��.mm`���h�{��P�p6PZ��֢����;E�+��{�a����r���c�h���]^��ɫU]G)PI�e�Zo%p`�.ʕ�ে����{K(�9�����"G˝{*����md�/�����.���N�����@Z`�g`�X�2����6��K��G��J��T^�3W,���JĦr���@��{�	��*ҽ�;�R	k��(���(8�����|�#��;�`���(#	���$�b䷟���	����H1� }c'���Q�;����5�z���m���Y3c\i��l�Y�{
L����OC!%�����Y\�=�`�(�(=�{{�� X߫��!��L�, =������t'~HЏ�����׭ks�.��I��J6 sJ�_{ʞ�|I�v�i}M?0��{�u#���������:��S�L5"I���f��������+��-����`��KҎI�����_�W ��p�qnw#�=0!~��{��Օ���0lC�w�y��p�ӬT$�y���E6�7�w ��.C7(����VC}��oe�i���������:y��݁,Z���1���xȂ,Q����`�p�9}�ˑ��ry����Eu��*5�/�ݞ�3=LSg�Cv�D�ԓB�W�< �\�|.�	��E�QB?tN��j\d^�,0j�p88��D�h� �֓Ӆ���0^[��{�+2��Qŝ��k8*�,؉�Zs:q9���F\�ƈ �)`l�wn%ە���#[��������Pğq78���+�r˲��2!2�c0������s�}z4a��7AU�=��z��Z�eAh),I� �% ����k��.Uŷ� -q.�P���+��ݕ������2�o�sH�a�=��;Y��#p���EW�����LE�5~_m�1R �g��� �C�07'Hiğ�#ӆ`yԧi�釓"@^�@��ds_��4%����Q:W5�t�Wy�8ΥNF�Iu��/�wMST6�P͆����1�-_��)!'�݇0���uܑ�\�;^�k�L�m4c6�V�Cf{, �>��Ѧ����f�hCm���ǍC����E*��jj��Ε�]�� �s]Bw���9D��~oX뵧��d@��@� ��A8q�5:+�Y��ԯcj�����ſ��^/����qCf� x�]e@������!x҆�C�@qVZ�s�7f���#k�˲$ٕnu�69�c�vTK�>n��(������HB�{�W�vJ�a�׷Z��,���N;�&�~��
�y_,�h֎|����������"~��.��9U7>}��K 	�VB�5A��S�ipf�ȗKr�گM_��Y��)EQ�6���˄#�m��2*����2��OOiP���F&aW�k~0���S��e��?p��J_W�	�+,��������F����3 �B�9��C�;5$�v����Z�Y{��{��2e�n �����	�����LUj/��hp�	�vJA�@׍ܵ��RE��Zh������ħL����ڛ�~�q�|�(`ӄ�݋7����ctC�xRK8nY�_`�~�[��V2��֫_^�T,��k�6:MӺ���R7�5�*�wdJ�� 5�� %�?���� 3���/�I	��<lm����EmǕY���r�@���0��-i?���F�ga���Mg9���F�C���#L� �L<�V��i��칁 �; �#}�byj~�{\�7����u,���6�9�Fy[�T��ڭ���A�e����t�S!�"B�<̧|�q�K���k��b�'�}Cx���"�a�O�'%�WK��f������V4�|�7}��[�F�F<P���~q7�f~
`�t�a_�|��l�B�5]?e,�W��^\�a�Nchv҄���V�=3���I��p���%W�Ś���$��E��2�����i|�0V���٘��o�K�a��(�Y`~H���9��)�'�@k�8B<�4�)���<n�VK|��˖�x��F����m�~_�/�?��6���m�x(>E(��=X���[�/|3�V�L��RgD�[�mP/#_���x=j�tW�����1Կ�9��=�8���޾�G߷� +�����-d��X��������BG�֠���EڳT����_�g�fH��8\�c�s�x@�#���}2����P����x���P�y �̀7/�a?~%����fiʻ���K=��鲐{���a�w���r�Z�{�,�H��?ǃ�Zy<��k8��g��'�.�H������6?��ʜ�EC�\���{4)C6 O����a���K�H�B�����x��,Ћ���W��'��sSO�����B]�\,<o�O���2y�~��!��봖>~j��}�T�eSV�S��z�3��CL�塩�҈w�T���9�,��W�~q��o����,G7�Ӥ,��lR�%d�����=�;& ޽�1���^��aJ ��8��|�3?��s���5(�|=r����[�fu��lz�DNO�<�[�\��zD �}
���"����{��U 1�9�׍@�۽� �^�'=}(���q܋.vM�<w7sѤ06�w�]Z�a:���8#? �tΥ�n�#����Zs%�MX���Վ�X��U��G�X@>�u��=9�Uu��Q7ϔ����Tgͱ�n[�}��$�q�F��d�VC�\���� �$1=��5���T*P�)��.K����k���MUv�V�����(��i"������l�����I�s(pU�������I%E�Ԧ��8�p�1����Ż(��Eee��k?-�XA��4���C��)J���*ƭ&���?pH@����/��s������V�b��$A�w�%��\�>�)L-$�\؄��ti�?��e�UB�qr4eI�1�����XV�����=��ǦOlS��r4�y?�1X�Rd��ā�����N斩��}Yw��#�ߣ�i���!�|kk�w$B8'G�Ym����W��hPF������k��%�T���-�������4�m�&g݃�L��:o��ʶמ�- �X3H<�L{v?\7�%v�^�)���+��A~�G!r�[�?���{s�[�C>K�Vl|��{��Y�?p�gwa��W�3�%���,��䅱�qU%�Q�w���Y���jn�TɕWu�����#����6+��7�}.��r=������q�p�Q��>� N�� �����`�(��w��:bI!�Y!V��)�_x�h����*w�MMR�}W�v����A�ٹ'��p�����0� ���n[���}.(3I�T�cn�}.�    �����ˑ�ޜ��Y�;Z�S2�l��m��qh��1@~�����Jr�J�vd��/�:Ӛ����֚z�R��a~�6��u�(�V��XSzQ�*E�,�r�;�%	�A�a�.�3U~����{�~RF��k��q�g��3`�h�C���;}}�"���Y��f�Q�h�2�:�ɽ��������m���^�Z�����;��1��x���q�~�����cJWzݮ[��� �[�g���,5~W` �}�w�i�t@����Es��E�Q�-�k� ���{�"�����6�<�Nʄ��	�9Og?�l�KqMG�_�V]<�UxC��M�5緓r�R��RiἪu����o@i�$Pu��0G9Rpw/�Р�p���lHك�ht��&�;��{�i:~ѻ��$���U0�����O����i	�.�Л�f<�lզ��]�g0ܫN\uN�Eݿb�O�l���Z� ���36���Ģ�+���y�I�G+��^��|�������az��������Ji(g\ ڜ~g�T� ��T���X���1�Q싛HT�8A\��*E�����[��I�Ͽ Q�,�.K������q�j]�U��5w�OO_	+�*;��P�\�{��θ�ێN����׺lp�á"�~�X�kH@��mE+�i�]����M���C���ɗ�|��P2�ǵ�M�o�Ǥ;�Es`�}x��9�$M�5:��Dج�C{ͰY|7�]X�p2b#4ގ1V�),O7����6��n ؾ������^���N7����Y0����uEp�*�	@��3��7<}ԽRL���7� �tE۰B��(��!���9ƨ��G	����Q�'����z1_![����M0��4�i���Y��е+�h.\��}���y �ƞ���i6.v�kX~�R�o��WU�07����_�X�iT���-4��ęw���50o}М�ɥ�����9l��;�jD�r<�,��R����+���$#M�#��w��P&L����hͫ�s����~p��0��>�D�#fi�)������Xn�˫����h~[��R,}g��'a��"���>��OZ�վ�����D�,��,`�������)��@`���Ħ"+��r[���<�k0י���X�*��4L�x_C���A�~�n��s�}_sT�s�`�0�͟�J-�=}[��~��x������/�أj\F<�ET)k��i[C
�R��&�N��5r���a����6@y�m��� �����!>�1"a~O9u ������� �a��`��v4���ݩ�`%��Q����UCܱ=�K'��Cn���<�d�#_����\wf��6h�@;ܘ�^��M�|�0G}�(�� ��g���r��aV����ݻ�"b���Ak�;~��)ˑ;�#��nog���6�r��9�p�~�uB����%���ә��E���a�����-;]�5��\cx�=��������Pz�������di�)w�8�l���|�J8d� T�� � �<`W���o�kP;���㝀�[�P����w�e�H�����#�b�$qTjv줳pAބPS���b
�$�n�����<���z��?���<��	�2<�+�E�����v���� 悗�#�����ؤ�$l�ʺ��GF�I*6�h1�C������'c�{�+@��n�y�h/y��;�77�٣T-�+I�G�h�f���m�@+�3�<��� d���4ЏZe�͝���e�������Մ@�y�G��ȯ�f��{�υ}�<{ο��.xݏp�f��#�����%�_)��nǔ3����[�����~^��K `�?��J�\�W�72i�����iH�8%::�~��"+���wb3I��?��Y�!Bm!1nuם�TW\j��X�&����TlN��/_��_�])����0�-�O /�ϥ���zͻ�,$��������9��Ź��\?�y��_1KEh',Ȍ?�:�	�>��z�7�O��*�0��B����c�p}��5�{����N��'�ci~&n����o���D��ZX/���<����\�7�FEh���ױmAY��"�P�*?� '��s�"��s�S96�0�}����E�zY��/��;��h*�sJ=~5)� O��yO��߱���]���� �k��1���>����#0y���l�Tt�[�O2���q�.�5��5v�^�渻��,�R�׳FT`h�?��$ f�_�;x���MyF �ˎA)�� =�*t�Qb�z9#��q���E�mK��Mj�㧬[\Y�M'.7�r�i&5�keT��Y��+ Pr ^~'�9�����
�U�Y&L�s��u/�c�r�-�lp������	P=�{u��ܓ{�0�C��7m-=���;B�������,* �)E���՛5]�j�ˇ](��u�Zt�ީ�vF̂e��0X�g�3|%!L���yt��ٚ�dk>�����{��ۺ>������c(݅(J_�C��L�C����]�L���^�ǧ\����$`�jxn=�/�>AI��
�.�i����C
�+�ÞJje�T�u[�=���Yԕ����A�&��E����jh���Z"��m{rQs�;	?���������� 1u�3�[l��2�j��&5u1��6 PT�i���� ���+�Q�(<���&��h�;�3��x�~��`�	c�U�^��X�9P����fJ}�ah�i�(g[P�g�8W�����~T5�[�כR^�̼��[x�
���}�jX�m�C��hr8M�.U�S��+K�oݏ�׻�kn����HX���@_�����2Z, ����֐Go0p���`oW���Շ�:��:W ����G�w�3׷Gſ�������ǛQz�n��%FWI��;��􇟫_��f���u�����0~�^�0��|���gگ|�0>Z�S�N�)��^�Od1��T����ߟw�V4Er��",1 �y����g���h���OSQ�0�fI��y_�eG͝����q%�j��	g�ᵻK�e��ͯJ�}��F�d�� ��c�pEU�ӑ��v���ơ(I��mT+H��(r�LO��I�����a�ۙ}�!��? u�w��\�Ͼ���{��Jh5�4M����A��i�.�,�ꦊOq���iD�$Ӭ�uNn���0r�s[��4X|�k���^�Y"5A���`8�;a"l�LcV_)s���<�h�8�kӗhO�_���3;�;G��qC�>ռ^$WC�/�-=��
�#&<����Ɏ����%�Y�וTK1��E�^.8ҝy��N]�j-�4:�r�?�Q)嶖ƣA�-P�{��W{&����/���?�D��+�z�GV�A�u�;Y�h���ބ��������>8KY������w0�;��ԋ�v�1�b���
�� p��M�0��k����bQ��@
	�R���̭�_�}'���Yt��;�)� 6kN��];P$0���S%RyT��V|wB��u8nc>4p��?@��\�G�[~������v���w�']�����lI@���6���9[�:q��b�w���@���dP�@�T @��Y�'�Z'����Q��_��~�}����� ���	�۬��z���o��܅-~�{{~�\Rg���	ܾ{�}E^b&�_P��v[E�7E�b�w�T3ol)����蝰Ƅ�p����,Sj���3h.E)�*8e牽K,�&�ƙGPzd�r��W�^����5���7�8���O���^�K|����y�"އ��i܊Cz�+XWg�a~D�	`/e�-c�g����3�#f�� #M��_}?Y�q��w��!���9��A�z�u������̨�^������g�$K	0�`|�c���������k;~����#?+g��7����.���w{ږ��J��ѷ��h؛[h�ޮC�O)D�
dE�c��]�L걄Q|崝�%���o`-$EQly`?�C�i����    �܂�*�i|�_W��8!l`�g1�X����9�g.Dِ8��`�g�[>xB�$I���4��k��W�ܥ��\d�3�����y��Vֵ$o��Q��=���}y��K��r1D����=<�d\'w�������r�զ�8����\�
��5�%F!��=5���#�o�����Evڈo���P_�=y�sBx��Xؼ���o҅��Z�Q����\B�����i7�"�#뺙��?�3/|&;��ϳ�b��G-Fr����X�w�
l���|�w���M�g�}�<̤s�2`��j�5rh���A	�c��+��O�.�y��Y�/Ty��;��w�Q�`����������c�(���)�VT<��W� ����Yk�F��|�M��?���f�)�U��(z���ҴW�2���!3�_2TW�����@7��6��\D��V�:.+.9��Ba��$�o�x(�{�he[le�yO`$���w�C�sm����;����,�R���$<l�qa.5Y����:���Ί�cl+��p�����F3���w?Z����B����%��ie��lg�ș��!�� ^���ʢ�*�a��nu�&�C�����ڌ�X��a8;C�����䎢<X�nO��"�̄�46}�|��v�k�숃��a���x'��w}��=A�����&�gL����N`|��lEJ���|p ���{L�� P��'JTc�76MI���髭����X�!�(J�G�ƾ��K��;��s��(Y ���oi�=���,-&^-���{Mmu�����pÐ��vVl����lf�7�v_1��=N��!�<O�4l�����o|��4�a%�;�sd�g��m�� lq+�q]�� A��?��)��L�q����7��}��_�h�����`�~(̏�����#@xW�JԒ�1PLIxx���f��"�u�`x ��֏��x�����cj�s���T���B�c�/K`O�n��7�������n����@�'�^�}<pT��i�5�6�jb�k�����I�-��5(�V�N�gb��/��zH� _@��M�S^~������Z��;2'*��~.�'M�aݽk\F�l��ȁ�~J�P[�$Y�Ib���;cG`�x�W�c�Opf�x��n(�7`�,  c0��;��x�uE�1�}���x���z5�q��B¾�
�܍/g]V�d�ɧ_�s�8&���^)h��/\��i���Q{��w�)�V5�B��#�0��q���u���	��=�Y���3��:��0�l��y^˺p�����Ҏ�ߌX� s�OE�bcT+�� ��9�4�4��m�[���bG���u�`,AnṒ����<{^���o["E�~ Y)�֜�u~�]���A� q4��Tn�?6Ыe���o���8�b�4v�=W����Y��YD��\옛�pV��z-�V��K%�q�{b	>�W��U}�S]Wհ�������~�Pb͟����o�x1��P����
����������WI�~����RK���/�뻅�f��������n�}�[.�=�CA4�;�a����(�y��u �#�jj�y�r��v!Vv+?�'��H�6eߘ��������n�=���5S=�2��!� 曦:��	��M�%��x_���j[%�g�&0�t�O�$C�{|���Wn�3�E���
�BIn�\�h>��<�E!��C}߇9G��s�?He������O�8V(Z���Ak�@�	���� \��������9<$:~������v�ɭ��*�mY�Pn����Gzr�n�}5$��?�o�?���:�E��:�ُ�� ��_���L��6�h�m��uD�VlI�s�Wk낏៽� �>�����f-�y��zL����0�aO8��$�.\���;}����s�!K�E
L~{��:Ȁ!8���P�kX��7)��I$�p42~��L����'�-X��lz-~�����$�J�c�=^�� ��ٍr
8�s�s�RÄM[����͕{�ty�A�i�v��m�P^��:`�l��m�dn�:i�yN�3��,H.�[0�5|��`]�`� ;G�3ܞ�W+Gw�㯫N�X�^�����>�(�?n��S6�HC0��Bo_���0�!́ںJ��2�M�����J�?��-��#HҰ��0ѝҸ�DB  �b�G� 8�����6w���oۆ��w$
�)�������r����>2�������k� �ŕ���0F,�|N��xz  ��}�4��S|!.��| .s��i:]��鲨x�-���}�kl~	��Q� �>D<�@P�iU�8�0ǅ,�nO0i�����wXÌ�$���M!ރ!+�"�6�޻�Ҽ��WSdA�mF�%A!���y�]�Yc]ZC���Ӿ�@��o�gO�������$�0�u�$p9H�[ppX��|�������#n,�]�0���<��yd:E�h*��W��Н�5���JϿ�f N�&��ۏM�E��<�i�k�������v�j/�Y�/��*�꾞�ź+~�-�rv�!\�����3����a�鬇[�K0��Y�E_MƙY:�Iv�w�vIǩ�4(D��Ã�������WUc�e��N��3	qa��3o:�<���q��{w`��4<d�\�1a4O�f�a���4U=D}���賰a���<b���9�>��P�@�6p�������� ڻ��c�zחG��w����6yo����쯚GdzwKG�ɟ gݴ�E^�r�-���P��4�:N��ՙ�ې���w��˲6I��#x8������5���.�z�W�k��}���.$���d�b�M��X�Ӌ��~�y����.��2�7ʞ�pr���wݛ
���7g���=7���q�i�*Wb͙`���-��~��F��;aC��>j�]��6��3O�K^dU��T`��'鉜^�1?sN��!�$w���v�79�4�3�*�ۋg��fٗR���*���33�t�#�#�[���]��t��P��لD�6A�.?#�`Z�6�˼y�|�|��� =�~�h==� �c����g�'�7E���LFP��"��`M� �!@�� �����(�H�IE�� ��*���[������dR�tϧ�%�a��C��R�E!�/����b����wځ	 wX"�?j�#�-�<���ɇ��C��{� �|ٯ��øQ���֓`�(���X�o�%���nʂkx�ݤ�m�~�m�K����(B�)��k�3.s��wT{i)R�s�Ov��)�9�|��nʯXn����@�;f���r=���[wbr@��O���k�I��D9 �Y�-�Ƴ�	�v=���E�FE�������$#��܉�ީ�\��S������]J�A8lx#y���L��a�z}>8�B�å �5;����Ѱ�`!N�W��{'s��j��D���)�
��N��[�\x����oZ|���� 3�0�;w��Gt�/�%\4�D�%N���������j�F8�!G ����tX�n��7a��NQY�C?c�7U�y��.��̉~yQ����c���;��B@Q.
��`m~{�\5�S�ut�������|�3��e <!��o����r�r�(�W��~��1A�}�س�<�/ �w�Z>*`�����@�e�N�R�xF��M�^j/
C�g}��~�������Xclb�v��������ĘM��Q�)V�������0���FB ��#��@�8�v�������9�x7+y��uJ�<�:s�uE�ޘ��rI���W	a���w�e0��O �9�x��D5�r��go�T*N�#s}r�,�<�����$J� ���0��UG,29�ISƭW�O^%��1�Vs�{��&0
���#���CӬ�m�vSd>_o�wD��E�74��v�e:�WF7��t��������*r|��[]Q��8�@ �  wX?�7T|]`�O��~lI5fRS�1�4Rucg�cs�j��=���>	���؊�+~�<��V
���|c0Y�2��n�|����;�����Gx�,V�3�ٷ<3��d�WQ_��3v��P���)���fr�~������'���Z�-���
����8�jk�-$l�3�S���.�3�As�o�4s˂��`n���aYN�խ(�	˓�\d�{1�|�~��3�>�Ê8��Û�#��;��`��V����B OӶ��Os{�	v���ؼqNy�F;58ѯ�灳�=��p�r�?}l�p�$z���� ��9�P�u�V�����<�E�^	��� Z���@���|��,=�5�{�C1��R����:hSs�y/rt�LS��fb��h%�F:u��Ya����rφ�dE��-�PX�f���s6�T������NF��x=]-K@ĵU�gdv\�37�c=?�YAi� ��OQ̩���,`ƫ�-+�pfm��#-L.��Q���� ���y^�;��U��黃�Mv��I����-��!V=�G��p����J�ݒ/��-�W`�Y=�|��lF��a�]�;�ܜ�=��5 S�g���q�R�a���=��it��v��y�����:�]��L�2�]�C�k��(4k��w�@l�k5a��C�	1U�7�P@ΤKC}�ׇH�W����n�A�M%����2�O_����"͇܌d��"�4}��-�pz��8I�fQ�xs������G7�x1]rG?��A_vz���`A��h���GQ�-�Oe?��y���1���:X}*$��H �S�G$���D!�.�č�0-�/��#[����Y+&�2�"����Gl����x�*�N��ozր��+���F���O?x��������\�&���	��#0�0wX����V:��P�]���`��hN��?QM�mo�߽���n����@��u찏f���� ���x��֔�8��3�`�����2/��i��w�:K���v>��_^�<�Iy]���r�\�3&H����7F�qF�֋��3��Q#�C"��~����������4���F�=pƄ�P�p�� �˂_+�{��%�כ����n/�/��շ����WG���W��>��
{Я�v��؟�v�O���]`L�
H�~5[����T�����s�
S�޺�f`x�O?�iVb��6����e-��14�u�Č~��Jڊf,M?{}޸�k�b,�'us}����l7��$f�>�\Q@���Da�M�H�r�k�3��`�]�,39��)ç����Ե�t3�"4�]�ڏ���O�\�Z]�}��[�p�.�Յ�Շ�X���y�T�C��mDCGN_0~�%�}C{�{���T��R�G��m�)��4��� =��������#B%L5fŋ5X�ƙ�XC�+�6�{O�t�r#�Ҡ.0����|�s���Y�ٶ�ў�3�����P���	��ި?�BS0�?���e.���!º���s���-&��W�'eh���y�+>�M-	,��8��@ ?�&�2f۶��o�������?��1w˳x�������^�������_��^"u-K��C�O��d�ҭIO\j�7�����0��s=}�{3���� yf'p���<���O��;5�(�ߕ������w|��뙷�x�U��������+߾��<(����T,C�(*��E��?8���9�8��I�7��?p�i��O��������Ć���P������"�\��� �����������5���s�?>��A�L��'��MA��j��Q�&Ț��Nq���U��%�7T�X��u]�NQ9�p]W<S1D��_]ݷ��o4K�+��/�������4k��m#W���+��_
��`N6[�6A�h�v�`8�\K�JRVR���)Q�����Ƃ}9s��Kg�6Wm캙�\�(��K�,Nq'�b�$��y�:R�GN�Ȩ�]0�Tn)�(M����x���6����t�O�+5Ǻ̃��ѿ=�>��ᕫ߳rs.��\,)]R�;��SVB,�`<�J�L�Bd�0Ufi%��*%K=]���K��̝�.�p�f�S��\Mh��]���@�L}���w��<`hc��|�v9����I�nt0#~��n>�vZ(���^��+d�h)˩�wN�XU��P�SC���I��Z.����=�y��Gku)΍���J�J�ea'�;C��߇�y����G�ҿx��؟�h3��-�]
N��X��?�9t����hPS�{S���(^8����s�;[p���R��H�"'�͐�m��n����7m��ԁ��f�e�j����vXYv��1��Y �4�&�C��`�a֦�<�_pJ��b��Z��I�^�k�ݪ.cw���w�䁶�-1n��2,5�H�)��<_�/�X*�����S�� dz���ߓ���{����r$��6æ�����v������!S�<4mQ���f�)�~�d@k�;y^�������o���_0mv�M���sP����g����"$`�mT8�ڈES3~^b�!q�QVR9���J�9�����u�����;z)9��8ì�',X�~[����'�~��z�������ˮo�.��M���&�>��省�گ�j�v�~[������_FSe��$�d�8<���������7G��v���x1�����3qI-��"�ֿ͚������z k��%��7����y?k\��Βpi�f�AԕH�NSsigo��*�~G����W|g�Y;����s_�b������7ٕͪ+�����]�0ȨiS)nY�C���bU�|l�.�v��+���J��B�h�e}��,�Y��!���G���Ґ� S2Cs)g�|�.c���_��r��:N+!�lG��"%X&^���yR��n}������]:�a�[%����B��C�?���tu�;㬖*Y�\e|������m��;�����v��?��xzLə��J3�`B��t�̥������Y�&��L���Po�E�ހmq��āU�ѥ��m�:%-�T�t�!�f�m)����@ӕV�P
�� ˴*J�(ׅ�'ۣ%���w2JR��΍���(�(���͵8H:����(�	c�5	���agT -=WtH���6����eo򰪓���ȩ�VF�p�UU�@�	�T���Gt�0FT����K���E���t�fwx�"��y��}���/�8N�S2�F@J�ӻ��4�8_T�俪l��E�<:w�S@�D_'����
�g��~AI;Wv�|74����� ]	� qʹ^�l�]����XVB�(�.���wT��/�G��ڊ�@�З��b����U��ml���M��M�ɦ	MsSG�+�	=֛8��;���}5:��H�m������+�Ǯ
(?�Ԣ��ĸ;&юI�\A��_�����ռ4J3�4��Q�G����F��>�<�8ѹJ3��i� k�w�$\S���>���9}�YFB`%
�Fτn|<�<��|d����QM����79�����YJ'�b��CD�����3����6J�=NrOK�����0<�c����!
K����+n�I�9���X�݂��T�1ۍ}B<�|Z�c�~��U��>hœ�4�-A9,q��j�02:�֝��>�Kꈓ�x=a�T��xF|�\��EO[���q �=F� �����PT4� ��l�� ���DoM�0�ۃ���F'����Xo�� �eD��*�t%3�B��h��>�!z�"��#�����h4Mo�rD3ʒ�� D1]����S�����x\�<Z��f����p��u�)����4R"�BTv����w�T���*8(Hpp5%�p��E�o�f?�}��ѻ�ö[���W ���u�&�M�z�Lж��7�G-�\J�`�̟6=���G����Oʦ��A���:Ǹ�������b�(��)n+띍BJ�=p�Ḭ��D���H���HP/�?�]J�ѕ�;^��|>��,�      �   �   x���K�  ��p
�V!��S.�!��b���ԕ1�ݺv��s���K�&2ER5>d6��j+��|i���=,�v��u�7 $6������;"*�?��}H�c/��T~��ѓE��oq�J��a0�      p      x��Z�v�F�]��"��H:C��Ļ�CI�T6-�Tk�[^$�*�(����§c~o�dnd��f!rԧ���*dFFܸq#bv�����Lɍ�ʪ췬)�����r��fJg���p�DNf���q�$^ዤ(� �f������<����܏�����?~��`���#V>�Y'��_��?�m*Y�~�
,�����4p�T�N�D�q��P�����.!���H��Q xx�M0��zݱ��֬���>Ȫ,��h���A�2�2G$�r	'����{��J���Mù����E��`�40���/c�Ӎ<8b:e�ӆ��j�[���X5=핗��eC��-���7,��V/�J�'l�d�j|�Z�nW���XkYw?�d��Dܑ��`����9��� -t��p40t<�<1��>w���x2������d_W�K�����hl({�:Ӻf���4�R�:7�Q�z#۲kj�>��Ds�"� �Dh�y���M7?=��6�l����B��M�y�vb\՜v}�ʥ>��M��V��fȪR��u^�S%"�"��o���w��i�n���_g!'���O��ňe��5�6Ri��g�'���s�g�B��,ұ�;�*���#��I�0�x�����σ���0J�# q�"�I���6�[�vs��|X?�Y�7Z��������	��堻�p?�4}{�0Z��qq�+Υ�*s���h�;��b�I��$�c��8�n���6���͝�p�n�*���md��fem��l�fe�B��u3,W�$,��� ��,��:��'@�,r'����`��<M���)�A4�>�.E�N�M���Z�?��o�^�Y���LFA�U��(C'(r��$� �S�@� �����<�c"�i�'��l�ӆ� �%6��˛�-�0�G���.�\���m��P��O�	
~3 ��L�o�֩tя���L@��xrw����W��t��\k���~��3�� �&r,��5as�Uc̦���J��B�`��x,ǆ`���j%���L��9�	�|��!�Ϻ�Ս�N̉d��r�꘩���e-v3��8owڗk�Τ��I�DN&JX'Nf�S��"U"R�>�)q����rT�=w�&���0��������*c����Z�k�i���ܭ�.�i������H��Ҹ�����E�D�(��{K	��қ�pt�`�&ϭ�H]ڇa�]q2*��/�)?-" N�b�UN����ڜz�ȣ�T-Z|o""�=������w�~fgo�������ӛ��?�������/ �Fp�&�=YY��X��Z�us�̚]U�]{X��\���`W�i� g�Á��f�rc��T�p�����RMUCW�S�ػ(k,��
�1�4E iW�z�4&l���/+��������N5H�[i�w��e�S�5#�V��`�c���x⿪�2߲%�ӱ����Jʨǲ�t�ۦ��{x�>j-r�GD�� o�~"&�ۊ����zS�[�g@[u�BC�'�?/^0p��l�7���;H�Q఍n�&'�����o;��vU�-nH�EAgٖ�i�f�� ܺg�K�j�W���C�O:���[�YA��) � k"#6ZuZo�0B0d��̪]v�K����wD@�'"	�wC��-�����s��6D �7����O��eMi%�� �G�$��+��*/;5t|��u�tx���/�����!� X�jS��^�m��7���Q�vS18R��|[l�Gj�7�Ae�W�Xꄭ�[�e�f0��0R��6�OZ=�aT������0�l�9��m ���	��s��1��.Lc��bY�*��*=��F�I��bĥj����p�(D�{��%l��+煥��C6���gGf6|������|[V�%~i�������y�6k@� �Pa�p��R��5�!��Ӣ�;�u���֥<��พ�n0ӷ%�sB�{�����<�E�r��4�S<�~��IZ����ֈ(c��)D{�ɬ���Z�����`e�O�q�e��B���3f�A&m����)=]V������}y�	�s۱� ��lC�jA���(��`f�w^�.7�~��f	Zh1w���J�J�Y }���Q�NUM��?h��������fV� qIjP�]��k�7d���Cr�
_��Q��3�$@0v�I^1G�	� ��_��)�H�o�̊�}f�銁l�&�U7�\O�u��ON�E��,P"����p&��gU"M�@gq���,��{��U<��'���4Թ��;U��T�D9�Ȳ8	"/�<��ۣp�b��-��=� f�B��w�0=��$��-�-t{�oٰ!IΜ��
 �j�\c��+��RYA� R
�	1(��C[�+k��Z����Z7�)F%g��VMG��{��;(�wT���!^��M�����q\p,��+��Y�m�O�B��V�v�XyN��Q(��"ʼX��`5��f����K(	C�Y�.���d�$5��qI��"ڎ��4?�N�j��)YKt�Æ�p)�%��R�>��e<q�'U2q�P�y�*����B&��K�pc_�;!!,�}[P����D��D��}[X�3�k��즩 �*�b��ә�b���-Y�j�����Z�C��5��4��q���{��|`?���[�MՁУ�ĸ-��)n�5t9Xm-˺��RҸ�溕���A2=/)�Tu"��
?��d�g,g�}۠ڙ-�Uc;��lњo�^��UQ�Ӂ�HKW�Tǫ���(� �������ӟ�Q�bU7�o<T�O�v��?M�B3+�c�1v6�� ������.��ҍ�e7�W���D�>�>��:�`��!���s�o��l_(����~�����+A�'�%�08�T��\XLM=��T��2-�cXv�n�q��%ed\�SA�+���#R]��=7���h�V�"�>�S9�ܰTE������(cr���4�q��Z	�	��
�iߑ��<T2T��ġ5$y�Ѝ�U�V��Q��r	U���X1������4H���k6�H�lB��0&��x��1fB0���A-Э�4���Rzlƍ���枓HU��-�������?���mY��0Lb~l��}�R8�%�=Zb���pq��?s�c/J�ɜ�pn�����數��^-޾\�}}9g�/�ޞ_�7g��r���%{��}:�:�p�޿��\<_\,���Wlq���8{~q�^���.��g��)G��� #p?r2�BU�(Hb+/�Y�=3ՁZ�nf���Ef����'��w}�)?=^/:8���7������ή>~8��Nw�7v�����������Y���᧻��.���3�x�^\�a�W�����ލ�|Z\�A�/���_�ÓW�wo/b��ν6A���l������$N\��s;�aS���6Ư�~�!�X�Ng�'My�w��<�qs>N���,ښR��/o��W�3��h�W�c0�f���@^��<ƃt�p�����W4���x�$�"ZW�$b#�Q�jX�]��m+9{�{�4�>;t�4K��'�rW1��Oæ4SU]A�-.'A@�oغ~@gl/�a����fO^�ttS��i�b|�܂R�Yanc�+YC�¹H�A�Fh����	]y�q�-į��r��Ƃ�f���#��V�ꪲZ�b��@����V�'z4.�C�	��r���.f����1#[#^��hc3���f"�GSk�=�[���	���RV�[�In�kY�/�g�wYB/Vt`��Ǖ��ĉuÃJr�_m}��fY��y��LD���Hg���;��\�y�ӄ1�`onK}7��tcܬ��fLڮi�}7�}sJKy!gg-������}[������f��Ja�nK0��<���0:j���gJ5��6�}ǉUa�5otg�G6� ���͡����d�]�e�_sAX��q�����x�ƞ�}�*������S�Y�o�7��i)~�Qש�!	�ǃfLy�$ǯ�D��ֿ0\;:��L!��Pi��杙\e=^j���]G��;Ӿ*T���OGj!��Rq�VҸ����}��G�oɢq8;Yrh �  �x����!v.0�A�Q��]��P yy,B�A����j��Ϸ%"
gg�������cec����G>l��y�p�ލ��wN�I5����Y��Z��������ݠ��
�U�k�f��Ɓ�,��N�{�e��/j�� �cqF�q	8�/%@�E��)�,{;�[�rܔ�����N�L�V�:*>m��E�|H��O�A��!�؟��(B����<s���N�X�P�慟Dq�[O�D=����Ƃ�Gp�������i��
��a�$�4�����v6r�ɑ��^�S���@��!aק��ʼ���\�[�`j��6��0���OH04Ha艉���;�����e{g>�+��d[��Q���c���4��2gO��?�zh���M3�dv��w�i�6l�$�D%�^m/����x�OC}$B�u��*4��VUcn0�{O6�T��f.T��Aʝ���*Ys��?;���qb|<��.�R�>��<|�����g�� �u�h�k'sae��^X����;+���4�o¿��^�Ϫj�=�ƈ��Ri�e���es!:.��{t,� ���,�"!�һ���FQ������D�Q�-�E��������0v�;�&;��I1��{m�
D��ۊ8����_S�u'G"�Ԗ}cC�]���p���>�����\��*�����ʛ6��&��t�|��q��M�l����1��v���ӟ^�=��K�;""��y�i�~|Dx��G��/J'7�      g   n  x��Xێ��}������R�_�ǎm�l6������nJm�l�M�F��9�͑���`�"��.�N�*�X|4r`��IV��Q�%e�=��TǢ�e�,� �� ��:¿܏�4+�?���ZܽV:��3[�J�9�<Q��K�*��8o�"h�h�4��MC?ʃ�(�f�`�^���k���^��}��D79�u����O�(ˢ7��2�d��=㕞F���w��l��
VI����(5��d��V�k��w�w��E��P�-k5�_e�L���\2qv|��Z��w�v�f�Z�V��~�G���B1r��8L�8�;G�%���	k)�$�ΚF�9E���cwd�4��9���B���ؽ��U��,M����>\���3��(��7�)�eA�`�}��ȸa���0�]������G�r�� [>Z���oy/G�CE>�����-��J�a��-
�ƞ�Qm��n�5 pV�S+���VL�u;		+�^�@�fj2�L���nm9_@�9C2�$���)7*���̱(�@wy|�������l���L� ���pKK���
�pḧXF�٠
�q�X붕5QV�H��02ݰ��^�=!�DK��#�r�SI��B8[�[��Ȣp�*�y�5��"��g��hakNǕ�F��7`UWD���G)(���ѕ|���F� =�i�pD�5� ����s�#I���T��g*��=Nq�@,a9!c\k*��
���<�k,�ǄB��&8�j�Πɇq�3�g|gP��|j>a���[4.� T-bL��q����>���4��h��Nm�t
hf���]��Bb��HO5p:��8e�tQڹ���o�U�9~��q�j;H.��N�S�O�2�0(�en��fqVK�;��"�URL�V����"��彴�����H���J� �]��6pK�36�gj\ǉ�T����:�i�7V�vt��e	�YI!��e�h����-��.�B��p�^��Rm2[.cPP�b�-�w�>}������]���I�s0ܘ�sq�$ŷ��8pRz�f�S��M�i�gI���ƽ�Ш�٨���w���'
d�h%�|�R�Ѡ�39wj3Ì����=�kRZw`n���u���Ɲ1����BB�Ҭ.��O5���U�5%I�(�c個Av|��"qT�N�9~� ��J�(D���#s����/������(���@����9�Z�\o#Y��7��4��S-��P�#r�T��x������ ŕ�~���Ci:�hyga�e�-n������Uf�km	s����n����M��[���k"ѹO�;��;�S��>�^H��q�#{F���C4ɱ@8�~��P-r/�RDK�j ��_��{C-x���A���f5޺_=��$� ��<wl�K�y��r����P��a���x��Y��g�� (B�K�D��Zq�H�F3?�X�80���G)H~nzZ��]����Z>XzR�6�ԫ �;;1ރ���翸����p��<��Ya֫���<�agxm'���0`iSm�#SK\���2ܨ��ΰF���X����=W~^h��nG!�u���/�$O.��pas�ʃO��� ��ڰ�=�>�3ߐ�3**o��ʭ�O\���([���%e�6�����PMM�=�>5\�t�'��f���ϯ��z���Õ�>�.+ې����0��"��鯉��Ct_�W���,��Y$��@G����7qo<h(������^���^t�[��~�tňOA3�_����:��<��0��h!�\e_:I�o���߳���az�a�M=���^d�-�����I�P��+���Q�a�$i+~:�>bzZ5��r;X��_De�߼�S3���򈞽��#Xq!�V�����֨n�$5�,�~�~�fqQ\HMq��SI��a���������	bu�pB���+DB�$s�E��9�(X�}�������);�I��I�U^���4�R�*�t�QP%Y0�J� ��u���5y�����5Q�sU�9�]��ި_;=b��V��7v��x��r�D5L�E�".=����u�UuTxi^�"�erv�Y�G�4_G�dA�g�w��g��pA      e   >  x��X[o[7~����-�ީ7;�f��A�ؗ/CK�,yuI��?�'i�$���a<s���F{W�x�{�uڪ�(J�k��]Kg�??{�_/���۟��	�"#FY���tUz﹋�%�C-9R�FO%pT��BeUZ��yS�h*��X�|�\.��*1�P=:Rַ�y�Ѝhۼ�|��C�\�Α���7e)v��}i\rM�B�J�h<�pP��ʭ6���k/��X�"o�>)F�'���$ee�8�]�d3��Uo���L�x<��2;�VM+9��LK�-�����rS��v)g�<:}u��w�0����T2�+	Dd�S�G���Ѧ�s,E�諲�k(yE�
��%�����������N�@D4I5Nt�A���r!qs�Џ�c'/d���8��lw�YM.���&/_�z^���V-�>FcT1 u�nt���g��Q����y�\����Ż��n�^��8�S
O�W7g���~;����.V�[��t'u>��ɯu�^��]ެw��O_���~�?��N���C�+�O�U����ħG̯�pv-˲�oV��?N�Ë����{����Uϋ��r�o��v�K�ʴ�/���&���k�X�WRw���\ԋ�~-���)[�����N��!=F�C�7���&��es�³��l͘�)�m'�O�~$��	�cf���1��+ ��0t	Uk�O(��*�Ms55�jm֌���=&���bMlJ�T�TI� l|s��qz<��M[�չ�I�*A��
��H�2�z�n����޴��z�C���
7s;�kԖU&�]�pp�*�l���:|��,V���jw�����#o��Bc�q3gT��:���,I��qHL23��)�4�����'O�~�z���`+�c�=���ꢊE�j��^��A�&�m�<Z.z?�6P鑪�ւy�f�T���J:�zp��E�g9f`�m��E���_�EŌN3Yj��r г�m�y]9�nTe�)�/
��Q��Y�XzY��g�ʜUH0�U�i)X��k��pn��1/I�\�ؤ֤�pG��Y�N,��u��拣���kW� v(:�z,��c���{�jǶ)�X��*a@�U���Pu�,��O��3|�O����nO��5���3�9+`=t����UB��r��;����aLG6HA*��R wY# �T�OV"d>!a|��C�lR�~�����@$W����T����kBzf�4ƃ�>~����F�S*}7PdoׂM��Cz��@�IW��S+~�~f�L�i�C+��Rmȷ� ���E�ôQRkZJ�%��2t����:�,�/���=xg��UR�������-�E���i��(� $� �q �Z"�7 K+qx��n?��by�Ñ�v�XȀMBE� ��49�Hwc�d)�c��b�E��2@I��40�{��B�'�v�?��)4�x�`�/�1׉��F�rĂ?����`����9}wp�f���'�gq�5���9 &Ԁ�GF\H�<�O��)	��^ire�L�)@=��l����j`��͗_O��w�����7#��-����`5�6X��gB��6�+@s��G)7������ƨ�M��B��+n?E!=���F�t��h���7�Ĝ �{-r��m=*)�;�۝͇#�u�߬^���Gq;w���meqTL��}�����v���,9F!��Hf}�����*�����q�;H�h諅�S�s�3���k�4Ψ�b=d�Z���S:�����i���	����H2*��C���9��O�B\����B�:�#���6�|��*�k��B�����1-��Ė	�HԲ��i�~�����*J�      m   N  x����J�0�u����� �0+�����i'�&!I���Eŕ�M�Y������"�"ZlH��E�g�H��,����z^2���(˻ui9��)��!��"z΋7��b�b�Wt��`�ʰ�䫜D/6n�u���L��
(�spk̡^�[=F�eӿ䲡%�%ͫ�w۶�6�2�/h�ߘB��߃<�2X�t���[�E���JLB/�Nx�V�c���f��M��5J���d�8�$OjZ���ctǼش�q��~�|`�:7
��<����xi�����>=O�3��R�� ��k��T��5��v����ːx��8� J���      �   �   x�e̡1EQ=�����y���"!�!A���E������]�R��D���^܁��bFQX�$,�OA�J��q����iӯ��+��D�SѲ�g�Z�*���:�s�O�9ɿ:q�q�%�      t   2  x���;�$GD��S�/d��$�,r�kJr]_�	�5�w�6��U#�Ya���ֵ������;��,ºЯ���Q���9�\:�]6��2��󏋀�@-/�ҭ5���o6�Dj�����\��]y�P�ya�y�-Bthνn�U�E�𘥏�� V�h���%i���p;�he�@d/�28�ƻ���B{�F��z�܌�RM̥�V�n=i�[�MZأ1��3�B�y��@������[p	�ss)�a����:��/�;��>s�����ȷX��XƬmT�M�.��i����B��d�ٴk�����0��4L%;�!��ڽ}��J�9��UhZKc]IS/-#X����ɗh�$
����]v�B��,`rSB1��W���?����&�au���s�ų��Z<�d��1�`B��]��	��8�����>�F�Bs^Џ�{����2�$�6w�uѻ�N�C"�o����f4`n(k�f�����#gv�� ��>[kLGDο�gG������vo�k��?
�����wp��xh��6��<�n�Z���sF~�F�kqv�Б�v�|5+uPv���;8M��1�~:r�[+�_GJ9|���(3}Ě{ ӑ_���xF4�����%'ղ��k��;���ov���I��SX�#	�������c�Q����p{����7�;����p��+@����'�(>�}�lB�F��z�h�����v3�s��Ô�QRǣh���F^�v����7�s2�:+����byaH��Ra�X{.�_�a�$����Z��s+85uL{d%ϳO��@P6˥r�z��RXi�o�m���(���(�%)�	~�s6�w�s)��nf��G�2ג1�].�7=�4:�T��ݢ�����ZV�Yz$��S����M�_����l��d}iv���C�?�I�8�oY&�����V��/�����?4	S{�T��)�X.�T�R�5K���8��on7���͎�k��O�%���Yj��K��>�n�֑.{3�I��6�V΋r^�ⓖK�%�,��5�����ޅ��RW�7ix yGЗ���xh��߾}��f�     