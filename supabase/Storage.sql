PGDMP      	                {            postgres    15.1    16.0 8               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            	           1262    5    postgres    DATABASE     p   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE postgres;
                postgres    false            
           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3081                       0    0    DATABASE postgres    ACL     2   GRANT ALL ON DATABASE postgres TO dashboard_user;
                   postgres    false    3081                       0    0    postgres    DATABASE PROPERTIES     �   ALTER DATABASE postgres SET "app.settings.jwt_secret" TO '5YZ2tjMP8Cr03qJWIss/J2sH4HUejYHLb6KIJ7H3wcxollPne4MZ7YMpD1HQNcsCgvOyTSjCj7ARros6cA5poQ==';
ALTER DATABASE postgres SET "app.settings.jwt_exp" TO '3600';
                     postgres    false                        2615    26990    storage    SCHEMA        CREATE SCHEMA storage;
    DROP SCHEMA storage;
                supabase_admin    false                       0    0    SCHEMA storage    ACL       GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;
                   supabase_admin    false    19            E           1255    27845 *   can_insert_object(text, text, uuid, jsonb)    FUNCTION     �  CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;
 _   DROP FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
       storage          supabase_storage_admin    false    19            �           1255    27120    extension(text)    FUNCTION     T  CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;
 ,   DROP FUNCTION storage.extension(name text);
       storage          supabase_storage_admin    false    19                       0    0    FUNCTION extension(name text)    ACL     K  GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;
          storage          supabase_storage_admin    false    472            �           1255    27121    filename(text)    FUNCTION     �   CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;
 +   DROP FUNCTION storage.filename(name text);
       storage          supabase_storage_admin    false    19                       0    0    FUNCTION filename(name text)    ACL     F  GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;
          storage          supabase_storage_admin    false    477            �           1255    27122    foldername(text)    FUNCTION     �   CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;
 -   DROP FUNCTION storage.foldername(name text);
       storage          supabase_storage_admin    false    19                       0    0    FUNCTION foldername(name text)    ACL     P  GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;
          storage          supabase_storage_admin    false    478            �           1255    27123    get_size_by_bucket()    FUNCTION        CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;
 ,   DROP FUNCTION storage.get_size_by_bucket();
       storage          supabase_storage_admin    false    19            �           1255    27124 ?   search(text, text, integer, integer, integer, text, text, text)    FUNCTION     F  CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;
 �   DROP FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
       storage          supabase_storage_admin    false    19            �           1255    27125    update_updated_at_column()    FUNCTION     �   CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;
 2   DROP FUNCTION storage.update_updated_at_column();
       storage          supabase_storage_admin    false    19                       1259    27226    buckets    TABLE     k  CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);
    DROP TABLE storage.buckets;
       storage         heap    supabase_storage_admin    false    19                       0    0    COLUMN buckets.owner    COMMENT     X   COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';
          storage          supabase_storage_admin    false    277                       0    0    TABLE buckets    ACL     �   GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;
          storage          supabase_storage_admin    false    277                       1259    27234 
   migrations    TABLE     �   CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE storage.migrations;
       storage         heap    supabase_storage_admin    false    19                       0    0    TABLE migrations    ACL     �   GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;
          storage          supabase_storage_admin    false    278                       1259    27238    objects    TABLE     �  CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text
);
    DROP TABLE storage.objects;
       storage         heap    supabase_storage_admin    false    19                       0    0    COLUMN objects.owner    COMMENT     X   COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';
          storage          supabase_storage_admin    false    279                       0    0    TABLE objects    ACL     �   GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;
          storage          supabase_storage_admin    false    279                      0    27226    buckets 
   TABLE DATA           �   COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
    storage          supabase_storage_admin    false    277   EZ                 0    27234 
   migrations 
   TABLE DATA           B   COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
    storage          supabase_storage_admin    false    278    [                 0    27238    objects 
   TABLE DATA           �   COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id) FROM stdin;
    storage          supabase_storage_admin    false    279   �^       R           2606    27294    buckets buckets_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY storage.buckets DROP CONSTRAINT buckets_pkey;
       storage            supabase_storage_admin    false    277            T           2606    27296    migrations migrations_name_key 
   CONSTRAINT     Z   ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);
 I   ALTER TABLE ONLY storage.migrations DROP CONSTRAINT migrations_name_key;
       storage            supabase_storage_admin    false    278            V           2606    27298    migrations migrations_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 E   ALTER TABLE ONLY storage.migrations DROP CONSTRAINT migrations_pkey;
       storage            supabase_storage_admin    false    278            Z           2606    27300    objects objects_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY storage.objects DROP CONSTRAINT objects_pkey;
       storage            supabase_storage_admin    false    279            P           1259    27328    bname    INDEX     A   CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);
    DROP INDEX storage.bname;
       storage            supabase_storage_admin    false    277            W           1259    27329    bucketid_objname    INDEX     W   CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);
 %   DROP INDEX storage.bucketid_objname;
       storage            supabase_storage_admin    false    279    279            X           1259    27330    name_prefix_search    INDEX     X   CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);
 '   DROP INDEX storage.name_prefix_search;
       storage            supabase_storage_admin    false    279            \           2620    27331 !   objects update_objects_updated_at    TRIGGER     �   CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();
 ;   DROP TRIGGER update_objects_updated_at ON storage.objects;
       storage          supabase_storage_admin    false    279    474            [           2606    27392    objects objects_bucketId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);
 J   ALTER TABLE ONLY storage.objects DROP CONSTRAINT "objects_bucketId_fkey";
       storage          supabase_storage_admin    false    279    277    2898            �           3256    27647 8   objects Any user can see anybody's cover image 1cmn924_0    POLICY     �   CREATE POLICY "Any user can see anybody's cover image 1cmn924_0" ON storage.objects FOR SELECT USING ((bucket_id = 'covers'::text));
 S   DROP POLICY "Any user can see anybody's cover image 1cmn924_0" ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           3256    27646 B   objects Any user can upload a cover to their own profile 1cmn924_0    POLICY     �   CREATE POLICY "Any user can upload a cover to their own profile 1cmn924_0" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'covers'::text) AND (auth.uid() <> NULL::uuid)));
 ]   DROP POLICY "Any user can upload a cover to their own profile 1cmn924_0" ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           3256    27644 *   objects Anyone can see all photos 1ps738_0    POLICY     v   CREATE POLICY "Anyone can see all photos 1ps738_0" ON storage.objects FOR SELECT USING ((bucket_id = 'media'::text));
 E   DROP POLICY "Anyone can see all photos 1ps738_0" ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           3256    27498 $   objects Anyone can upload an avatar.    POLICY     w   CREATE POLICY "Anyone can upload an avatar." ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'avatars'::text));
 ?   DROP POLICY "Anyone can upload an avatar." ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           3256    27497 .   objects Avatar images are publicly accessible.    POLICY     |   CREATE POLICY "Avatar images are publicly accessible." ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));
 I   DROP POLICY "Avatar images are publicly accessible." ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           3256    27598 2   objects Enable insert for authenticated users only    POLICY     }   CREATE POLICY "Enable insert for authenticated users only" ON storage.objects FOR INSERT TO authenticated WITH CHECK (true);
 M   DROP POLICY "Enable insert for authenticated users only" ON storage.objects;
       storage          supabase_storage_admin    false    279            �           3256    27584 1   objects Give users access to own folder 1ffg0oo_0    POLICY     �   CREATE POLICY "Give users access to own folder 1ffg0oo_0" ON storage.objects FOR SELECT USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));
 L   DROP POLICY "Give users access to own folder 1ffg0oo_0" ON storage.objects;
       storage          supabase_storage_admin    false    478    279    279    279            �           3256    27583 1   objects Give users access to own folder 1ffg0oo_1    POLICY     �   CREATE POLICY "Give users access to own folder 1ffg0oo_1" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));
 L   DROP POLICY "Give users access to own folder 1ffg0oo_1" ON storage.objects;
       storage          supabase_storage_admin    false    279    279    478    279            �           3256    27581 1   objects Give users access to own folder 1ffg0oo_2    POLICY     �   CREATE POLICY "Give users access to own folder 1ffg0oo_2" ON storage.objects FOR UPDATE USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));
 L   DROP POLICY "Give users access to own folder 1ffg0oo_2" ON storage.objects;
       storage          supabase_storage_admin    false    279    279    279    478            �           3256    27582 1   objects Give users access to own folder 1ffg0oo_3    POLICY     �   CREATE POLICY "Give users access to own folder 1ffg0oo_3" ON storage.objects FOR DELETE USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));
 L   DROP POLICY "Give users access to own folder 1ffg0oo_3" ON storage.objects;
       storage          supabase_storage_admin    false    279    279    478    279            �           3256    27643 2   objects Logged in users can upload photos 1ps738_0    POLICY     �   CREATE POLICY "Logged in users can upload photos 1ps738_0" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'media'::text) AND (auth.uid() <> NULL::uuid)));
 M   DROP POLICY "Logged in users can upload photos 1ps738_0" ON storage.objects;
       storage          supabase_storage_admin    false    279    279            �           0    27226    buckets    ROW SECURITY     6   ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;          storage          supabase_storage_admin    false    277            �           0    27234 
   migrations    ROW SECURITY     9   ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;          storage          supabase_storage_admin    false    278            �           0    27238    objects    ROW SECURITY     6   ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;          storage          supabase_storage_admin    false    279            �	           826    27424     DEFAULT PRIVILEGES FOR SEQUENCES    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;
          storage          postgres    false    19            �	           826    27425     DEFAULT PRIVILEGES FOR FUNCTIONS    DEFAULT ACL     �  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;
          storage          postgres    false    19            �	           826    27426    DEFAULT PRIVILEGES FOR TABLES    DEFAULT ACL     }  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;
          storage          postgres    false    19               �   x����
�0���S�.���<�O�K�(�bJ���ڒ@�2�a>�ٮ��Y7K{b$k��t�8i��d�: �qv�����1�#��J����!:mI4&#���γ�ϸ�T�
�S$�(Q霻����?�٢�0��uJ	)N���;����M�T!9jRAAd�}�-�~�O;/�uO�t+B�$$�����[�[�9� }�|�         �  x�u�an9�Ϝ"�@�H��Y
�H9�u��w�=��N�-�.`؀�z|O�~6�ly[�g����l�6YdmTS�j ]@0pG�1���5�XI�`��x
a�i�3�4�i=��*�_���s�8�H���J4񨍈���Z�0�0�������q����8a-����{,�1+AQ8�E�V��Xv,�i��}8.Sk��S��9�0'K�"䞅ht��1�2� 3����[�����)k�!8H�s�(t����N�p�u����qo�.,Gy�e=.{��r��L��)�!u4��R�*�~,�E82��ӻ�vZڵ�ͧOMZq�aƖFK#��<R�`���`?8չ����vX��l��&,�Ղ�.�3�h�I�!b��`�R���X�/�s�e����ԃ��ن�P-����|��v��飹N?���.��H�C�>�5nUC)C��U�X�m"62� s�0�pwf;����o���߮�z+�Ǉ���3��hn�f��fX�T�@*��.Ņ+<6,���yz���E��cQ��~�ed?5-��$�{�;����=�$�s�H��&�\e���.�]�ϡ&�2G�},{�׋.��m��wo�`O ��F"�;&x�RjE!�P��C~�Xy�i�^li?6_�8��7��х"��ۺ����-S+S�G斸�=�Cd�s��r����b�m9��ܡ��%E?(��j�]jR�-Pz�ӧ���)�Ў�3���]囝/7�y��S���km�A�9iԀ�����N}�)퐟1 �c��|z_N=Q����~L�rKiܮ@3��FG�Q�.��H�η�ļKx8�\���U~��_V}�����ٺ��㗩��1K�~�7B.:
i��������5̏�*���y�����/            x��}[�ɑ��̯ ���:�y����{� ������=�-٣����u�U]ux�ɳKađ�]�Y�9���V=�\qF�FF��ӈ�G5��o���w��Vc6��<��x��8T�Ú4�w-����}V>h��kM�Ԃ
���{h��~�wF�4)�_h�ʚW^ߑ�6���zu4�h��==�����^���O��S�Nk�S���<Z*>;�um���ῼ�����x�&�v��������~���aڠ���(?Ys���������������῕e�M���?߷��uo2~Z��~�t������¯��~������l��>��!?����,�h�����?�社�Cm*���A**S	*�L�b.�'	5pb����W.��qST���w���.����+�ＷV�Rl���Iak���L�����`��0�Z0�8
<456s�J!�[�t�԰)���D�"iߌV�g��hFS#�l/�{z����ssV�@�5YCO-~a��[���t=ŋj�J�;�i�~����d�_yv&R���4����i=��)��B�v��0�F=�Ǧ��'�$�^j�b3����%w%fG��[LQ[��A����Ԇ
:AV�{UJ$U������%����� �����B��e�<��è�m&F�::{v&c	#y7j��h��浫)�Ts�%��H/D������Û����$��dS��_�2NV�J�ؔK�TZ+"���"���w���w�^����{�>7����;e�dA�HH�����MrDik���lۻ+�v�Z%bH-�Md�%�f�|�]J0�__d����n۶��v=��>��(Z����J]�꬇�E�Z�w���!���}���χ>�s�_�ye�+Mw������xk�FO��v�T����k��*�c7��_|[�(��]�uɶ[}�_��6@��/m�m��5U%o�CoR�\C��^{�KiZ��u�K�rL75(�Fպ^��R�xW~e�؆��3u6J�܅y[}v&ӡ3�ڲg�?����_cC����2�@@�D~'�_�O�>������߫�E���[�6<.撄�s�v�Sp�JZg�-Wj�|�XE�T�`�� G@b|�M��RvJw�O�� K^Px��+��^<ړ�棁�7�5zzv&B����g|R�%C���j[�F��Z�[�p��������0�%���ncR�EP(&�( ��9���)OS̊oE���>`:�cpC��b��/OTLK/&��vf�O��N������3��@�F1�g��i. ���0�¿�ZZ�?�Ֆ����$_�J��*����+.	o;7 n~���s���E6��/�\I���e0�D��X/�^9{�=��[��è��&7GO��9�虵��[h=<�M������X�1�m��/��n�n[�\4�Y�T�5h���[Θ��Qzs4��5�Aٕe#",l]+4�����{v�XF|�Ɗ� �?���Q��+n��#LX]p�ڪ=G/��]��7�����p�#k�߯���Ob�`$��t�@TNl�Ǜ���3`_^�{��>(��lǯl�#�ӹ���Z2`�[��g�AG!y��\׃[��C��ǧ@�Ϸ�9=�S_��J��+�vd��/���Ro
f�PQ���J��Vw����.���S��m9 ���Hj���6�lԲ���ӳsWu�ю�%F7�3��F1Q��b˭���M��a�Ը��f���հ)[]Ŏ��X�ۂ��y��V�i��և�c5�2�.:в��i��;cb�G29�µ=��8-��1zj��
���/�K
L7���2��&���0�ͪ�b$4����Zu��m4�wo{{����o?<���߿i��������̮�����9�43��Q�C\=v���Q��4�.X^g���^Gr&.BK�?|x����߽|_������_d����6��9Cb*l�S�����x�� �TBq����44�� �F;g��G��`�#3���o��얺p�23Z�(��f��7��ySD�÷�{;ny����?���|��Dy�p�Qb�A:�%��m|��	|i �9Wb�!e��mi�784���/��i����n�����N�Dζ)|3N�t�*)t��]K�;Ln�Q��8\��5*��@��Ċ����/z#t�^�������G1�x-��xv&W��|�0�J�#s��i)�(D��K얿�i�1z��n��O�_����b���?�"�<tk�a�����s�x����g��%hbc9Y��fA1�+�$���!�9��Qs�^��Gϟ����^����F<!fK	Ԣ�y�k��܆�j�X��?�9��F�o �N��
̆�������d�������9)�Sh��s�γqt�B�Q P�==;? k�Ec�
��!��r���E���H7��8�Av+���'��5�d؈��_:�ޔbS���p��8~��$��I1��/��;N����ٝG����[>�����t�s3�<YQ��������#鯦4n����H�Mk�����L0�	r�B�����Eh5��y���36zUF�y�˞�G��� ��pE' }�a�o	��`��~��Q����Z���i����* Qp�]1I��g���0z�^^�����7���&��~�������������?��������?���l���U�vօW:��D���}�Q�s��[�F�g�io�{�/�F-�"Yl��F.����j�m��~!��r����r��ǯ[��i��������o�U�%/��ϱJ ��*خ˹Y�4#�����(�s۹ F街̮;�y(}>�{[��g����M<JeM��[M)��u,q���_��L+�߯t�&���1��G�r��jTO0P�0>��7H�	@�jN&]�&��Z���?����?~�����w� �O?M��	G ��6O����D>�Q���d�م�1�ǆX�j)v�p����<(!M`�70n����b/�~�x��}	8i�b�ި�r�30�!_N"fK�9O��W����������dh�ĉ̈́����N���&I����d�M0e�] �< D�ƺ,'~i!C&�tO�&o�%b4���6�b�/�"p05��5ܨʕ
�>�WRq 0fTs���s���vWr�V��n�0�5zzv��aC�V\�N�mp �7�����t�&��`@��0*�LP9�
�U�8a���s.�^Q�82�5�3�Z���m=;7Z�B͠4	>�dй�,F��/>���F���qIX酠�~����H��x�X]��t�A_����so�0V�Xl�$�V���L� �׏4'�1e'�������&)���$t6j<>��5zzv��Sr ��]�Fs!n��%�,��X"jM�o�sܔ==��^��<L���x��LW0�Ф�X�l������DISv����ڍ"�W�����p�[0�lcz:��������-�G{���Nq��������ڮ���'�8ST2�c��v�\�uIw��D�}ݍ�Y�]=v�	���7�B݌��%�)ݜ��z�]�VJ��a�t��H�	�u��!I��K$/Y|���I�˟���������E�����rž�8n����s�@����Z56�R��iap�pԛH`J헕^�����>��IB��;H<��U�&�LA��{����vNT�n:�X��i�]Z���'��=��NƮ�sHW��,	�@[e�AI>h�Q��Ӟ�@��X���}�CfV�ӎb�/?W��"Y�m���z.���=6{k���7W�E���-�Ϧ�>1e[0��F�4�D�����t�������S��?�艱S������fidt
!R�F��(4eUp6��>�V�F���Ķ;̴8t!�������-6y�a�K�_8�M;V61�TC���
T���<���Id�|y�_��r���K8����M����v<���fCi@k�-O<�0�G�䀌��ſ{��m~���2C븅iJ6��$+<�z�̪p��MX2�ck�C���70    ��g�2�Ćo�v"H�r��_,��RG�-�2K(L�_UcX�d�+�)����xU\���y�J�y�J�$Lh+�K�i:î������Gϟ�둅;Ϛ�װb�H��m�v�\H1��ߠPLVz�_�v��a�g�#:PѨB�Sn�Pٴ�,<��^G��y��gLK����5�4��kg�FO�~˺×
Ůҝ�h�������VWٔ�DlS���ʈ,�R��d�V1�����膫	5Ma�k~����T̵���u~^'t6j��>n�����,2W#�G����a+Y�		���!Y��~����/�_iL�ay�T��ȒJ%dE�����?N���гf笥������΃M����o �X]���LM�e�C(I��Wזc��J�Ew����=q6:���-MήH�b�<�P�ѹ��P��X��P���Ӻ)9������)������d��й3'���E�J�L0d̮xm����t�.֥X{v��ӹ�n���q�u��� ���!�r��)?
��7���R����E%�t�p	��R��z^%��H�����oL��k�@���������N+�w0�p�x�
�����z���A�2=���:� Bx,IO��_d#�YR�������x�T(Gp��[!B,�H����;:c�%	�Ѹ��[��Qs���f��t�>GK9�l����c֋��H��&{n����FQ��/��s����,�@P<�G����(Wn���tyI#��렭�����IR�7GO�.̏4�(�z�A5�6<5/n:�O-+���M)T�߯t��&��p�Kp�`��9�3y��>��/L��-߮�1Sڗ�����]ݍ���=*Rx���خS0��!���b��J319�<�qN��)얺��g����ʍ+*V�	V�3��V)1niƻ�w�J\^|e��ɕ�i����g�=��@8���E�>�h�X���oЩ�X�v��g��;;��J�)'��eek�|�t�#[�������o���!�.^ԧY}��u�t�;�F{}�9��%���j��KoQB�j�����u"�-�Ô��[����)R�W�R�&\*�!C��^�c�b��q�����U��8
a:�#u���hM��|��y[�F2x�͙\uʃ��Ͷ�x�(
���*���s����W-��U=�^@<Ueݭj���mn!A�������}���Ë�M�/H�I	gz������ȯ�$��5��?:����`��ʚ��h�ݥ���<��4�;���>�=L~��� ���I�7�
�anpt=�>�bN��	%�=O��i�E]��iԳ�!l����6�c̥��`j
��9�L��"r���dC�E�QbX�Ff�X���`�4�A����c��J�8�:�\�b{�
���gh��?,B�ď��M!̚�l=;�5]M��le�����%bi�l�=!��oB�v"tSG����/RO[��O��K���24C��d�D��^/Iڛ�{E?�
pٍ:��==�-;F�\��hPUDR�(Bl��j�hབB
��X��{�)D�R4�+��� �6n����7�bOudG 	���QFh@���i�:��.e^�m=<�~�vM�as%�R�ҵ�n�
���˰���ZǇ��S�CU�U��+��Z������]��p(MajM��B�Ϗ|�7:'�Ҍ/������������"�a�x}�%��b�k��F��~]f�εE�&wH�{���@R�QR�=\��ߓ'�}u
T�)i|���fHKҽ�\%����w�ϯ̒��ϳP�d�LIiX�؜�$y��L�R��ҵ(���J�d�M�/,��B�uÉe��_޾�!J�n�۹�����Pk�p}4 _���Y9Kf�����sR�9�Fvq�9dagj�v��������w˳#�&�.>�,Qҳ���+�dvѴ ��F�������Ԗ����{��Sͧ������Nӯ�c{; �*CN���N��ZC��Vku�p��g�)3�Ϩ�F��:�����t����z�7����v"c�"W����S�`��)E|U�Z9�'�������N�z���;L�.���LE6�g:WT�5����c��wtj���$��+J%�G�mmx q,��$,�k������c�����?���)��c����ؓH�篏�?��11�Ĝ�ё�K��6j�H�ܼ�j٧G�<�Zy�*�p�{\�g�`K�V�y K+13ۥ[7�jj[�i2ܼ~fą�q��4'�"?;��7��ba^�6ecV����E���V��o�����ō6��E�%Dx��bN{��j?�E��3�0x�W�RlS@���N�k�� MY��5f
B�?>�p�3F	�@HZܘ�75Μ4<�j��i�]�ݢ.A�z�_�ve�q��V��Ұ����l��=�ֹV��v	^�fX��H��Z���WB�1�s���Lη&�ۭ}�np~�g� *�����NДZJ��>/cz|H7�\'����2����L�.˕C�b�%X�!=����[�R-^/� ��ށ�a����(�P�0�����?��/#u�x�����9=���}��M�
KW��-("����;��ԏ+� .���G/�$K�M'X�p/�xL)���5��������
،�c+sf)�f��]��|#�o����9hw�s���"�`�Y4�sN�hzt}(	��r��
6��S��S$ɫD��~��l�ĥ�!�ZHI�_��?�d����,����C���?H�ɻ�����?���?�7���o~\�ݞ�|H�E���y������u8rf�$1 ��N-8�en�Tw����d%K��v�}#x1(4�*��Ŀ$�G���!�q��O�޷l�*��MT�JLQ�'Z1�H���ϯ?}�7�U޿������Z����w�����O�>����*:Y@�%e�J�@X��3��N?�58����H�P+>�
_��c.~��l��_?ՀW��B/����o�T/�_�����f1椢��]�Tv���Э� �$�Ym�+Z%Jlƒ�g�a�Z�H�tUx�������:<�O�N��r���yI��((��]<t��4���N,)E���ܽɬ�\H�����z�_�>�~�ȴ[�V��,eAe�%f�.�LS�B����� �F�u,}ŘxUvr�e��du��o[��宒l�f�(�һ 5��|R,��:Q<�ރd}���:Z�&��X6V�XO40�ڍ���HXzw;G2�(��v�ٹ�%,$:��ܴ���ފ�V6�,'�^�$C���B	�q����֋�C�2e�&AO�(�&��G�:�e�\���N�KpI6��v���n/�����^j	y���$�flT�j�\4��2��9Ko��d}J�%F�R{�:��0�k��J�������oZ{��D�i/����j�V䶙�+(�Gr���˩Ŵ�iW}U6�!����=e�ƭ\����k~���~E��"3#��]t��R��MN5D�����b�y���'�g^��|�y���/��M��7چ{��I�d�v�J**O�p������A4��Lx��#���A�;�],���+m�V�*�A�4�;O:ƴ��O]dJGV���"� A�Ln�\ �GeKr���I헳��Z/ts9M�QO�C�NJ.�ӂ�*���բ�<�P����/ �4"~���_6$��b���f=���]�ݵ6-*ƞ3:?BO��z��u�x�d�5�{i�=�{{�h�^.|I.��7�'V˜�"�!�?�d��|�A�Br��p���a�J(
�6���ϥ��>n,9�M�vuׯ��Jpɜj�$�O9�h[7\
/$Ʉ[j
_��z�|]"�}m���6��w\$8�]j�9=�3����@���C�撔�D�MgGpu$@�p��7���<����ʯ��	�ߴ�]�^��w���DS@��f#=�2{ �� ��j����]V%	�{���"���};�����Ϣ���l��$M�>#�� g3�xb�.������.nI�>�RKGn��@��g�tz�ۜj��    �/�{z�|��%3�\5+H��X���IhC%{�7R<�V%�*(�Ėr��JUz ��r8PI}���7��o�c�S~T>�?��>
�������SH��G�9:?���GI/)}(�I�{S\r��u�(�&�p�_�v��0���Z�ғb�N�Œ���WR:��;2]�1 ��������|I-Q��Ϫͮ���zxt������ԥ[='O�������������C�όe k�E�Y��~�ۇʧ���֘c�=��Dl��}������2�oGpC�\$Q���96UmLZ���8��q�ʮ��Ų��
\eւ�8ꤓ�t���5�VL��Uҳ|��� � ��[�x�R���۰�]Y慌����2��)v�������a�����?IM�������y�_ӓ'�λlS/P$#�H��0z�ч��痡4-�Uo�F�;N�ѰB�e� �n_2�n��aWL�ΏI����;�����:�J2��N�F�>\��8]�0�_.��!c�@����έ ���#Hjp_��ցZ+�>ڣ{�)ݠ�|Z��~�j6�o�.|vȴkw1��:�na�#MW��;HK��9�,"����N�:{n�h�ѐY�d�Xh��M�f��[��g�jUz�����S��6{�{p£��(ݢ��h������/����验�z��/6�w���a!��=_�7r�>����yS��h�����=���l!v 'a����5�Ago�/�������\j�w��b�C��U�!��!(@�)6h�yg��ٗ�"��$�<zpK���E'�H[L&'�3X_�ҁ��Pʲ������R/ub�Ͼ��5�{�]��%*�@|��|K��LS"l(��Ҕ�A�0FҦ�iP�H��y'�u6�MS�v���g_��(�;�5zzv���-l���<|5�6�5� E<[V-&��َ��J/d��'�\�mK�8;��L*��6��4F'6�[�a�����ŭM�Z���7��P�,e����_�:�o(D�e����n�n��_lc)�Z�d�Rn�}˕g��+�g�'�ڞ���F���f+�!�h7GO�η\z��L&'��%|,'�X���4����ݎF�O7�e��_���r+�� ? �8=����m3u����Ȅ�خ?mt�� ��2�0\� ��$�W6#Ŷ��ǻ�W��ٗ�^H�8N���z4[aU� ��|������m�)�)5���\A�w��Q����<�Nj//(��4m����y+0��Q�Z���1��-�e��H�oG�>+�����ٓ�e�.ykV��fiN%W#��v�p�C�H��fA�)�nG�����fY��d]��=gt��]u�_�Zn�
�^<u���#tx�e��\��n�j�J��*q6%V��<��giw+�:�T���d;��vMI"?+$]Z��.�:9�s��<9驍s/煃9�z��cd��;���D ��CW�J�*"0s���۴���J/\�|#��K�0�G��.�%��	e�^�B�2�j=��v�Ə+��]I�!�L���t�Ry���-�5�|��<�8
��h�E������[J#-�Kb ����a�"��Jr��|�����uux����o CZ���o0gM�X���\��q.�'���vʇ	I;�W6�I��R���U�l��L�y�묥�ٲ4�`��O���x�i�
���l M�H|��
A�)���S9yhڑ7r�Ւ�P �8Z g�9k����������Fx0J��v�<Q��0��z�µH�O���$|t��ܗ�D�_�Q����0��`F��`��N�V����0�r��7��rf�j�bHP]�iD),J�DU=�-�D�{$�j3��D�����n=;�. lɾ��-��͡@u2���/x�s1܄�_�[�_�-�Bͪ�XN{V��W�ϖ�s��|���������~������u��gpS�����3G簸D?��k�n8��X��.r���- ��nY�v��0���l�e�}�8v��d`� �uF!MS-t ]1V��V�'KM#�:�Bpԇ���pLF��{E��J��T�����<�����S�9e;��i��s��Iх:���EVz�_�v��a�K� Y��䤀t�d\7��D+UZ���o��	Z웋��bϓ!c7����{�aZ%;��H�1R�����,Pgn�<�����OHW�n��w�X����e�* �����Γ���Ƹ�tU���/��秞�&�J*r|eҝ�b��b���yR��+�V�I*6��KF���e�y�;ce����n;����b�Af��ګ�����bΪ�.��T�`�;���4LIU�{��)w��b���)�O��yy����"{儯��Y���n����4:��ők��� Gt�HZ���+���U����6K���g�:w��[�D�N�����*'g�Ѷ[����&`Q�
`>�6�pa�G�S/>��Y�E��������.>gt��9�QFnp� ��@���E�Z��JY�� l�&l�[�Jg�H��,�������p����m ��)�	"iI
7�iSd�ZQδ�l�O":˺�:�[��d~��1���'ɛZ���̀��S6%���@�ޠ��ur9ξѝ"��hg�R �k�M�;�u�K�kr�qP^��]8�T���cC 3V`���֖i^����!0��$�@Lm8oG���aG�)-�P�1�&q��޶e���exH� ��9HQ�����hH��c�A5�.����r2��f��)S�4�l��dC��Z?ot�}'�z�$�j埑��Iۚ���$o�M
��<��7B ����*�=�ac�
 �@;p!i����8�n*JY.���� `��\K�П����&&|��������09�A�*�ܒ�]��I��j0�n�;q�l�o���G� �u�Y$+�F��Z�t������\Q�č�P���j�;��cFe*�5��"��8�A)�[Lr�pc�����I,NB��y����y�����y���_,w���a���D �P��MAc���������z���q�dG)r���l��Ȯ7P�
�d)_���W)�6���D)#P�g����
hK
O+�?��U����Ifr��\[�1:'c�`�+�=�K �|��:k�PKHO!�A7���?.w[�����`�wIw.N��yɴ�p2����R��
�bPn��H�Yҙ8x�$�}����ó�?%C���+�}����iG ��6�AЂV[���H�ެ��;��/'R��ȇ�1H�:-7-��]j�L�bݼu�:�O/BUԻԌ�b�h-���#?��?O퓴͇���WE����U�a��A�X�9 �Y��ߵ[�{�-Z��i��Q�~ۇf���Q��]�'+ <1@��c��܂tûJ��`/�AZ���RA���d�����<ou��Z�)�4JFg���\4��;j���S�����5��o�X|�\�mr/t�߯t�~�0��4Q�+p���� N$��\R��.�tF7Ȫ��:$�|NV$]#������9�ǝMRdM�:����F�^�b)@A���C�J�̭w�x����ͷ�;��K%D��7�/�i�s����}*�5%}���Ԉ ��\f�j�b�a$s��eĐ��$�n���{������=NQ��:����.��]D��8Hcg�v����ܽ��w������F-��n����q��s~�O�QU#�b��r�n�Z���ه2���4βK��* ���`k7�UH-������}�������U�x��<Y�f�,�c���Y�堭Ku��� $-�oC8*C*!�o�j�j4$�b�pV���J�p�b���@ ^�/{S��Jt��/e^Y�V=W���qLf��\�17V��#��B��J�(n�r$i�J��`L��i"�glv�q�q��V� =y��+��<g���/��ֽ/�)�&y����	�b��9�_X���n�rY�ޱ�Z/�3�Zn�P=ap��gS�Z.0|R%P m+	 n,ﾈNc�7���m�q� .  ���"��UՓ�\���VI�z3֬��	3.I�P/,���a!+ �!����܄mޛ�؇dXɒA�vꩣ߬�?[�s�����1M��Q�����
U���W#}V}��`N����dU��s��Y�#�Q8�ȃ<u�[ʻ�>(wi�x@c���ɻ�N����u��wl ��$_Lzi�Ya��b�t����_>~x�_�p��1r ��*^(��j|�::O���,ј�Ի4`Ki��ďP^�ߠc��[�f��鷘����&7H�iϤ@ߢ/r��.��Ow���� d�X     