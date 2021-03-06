import json
import csv
import itertools
from collections import Counter, defaultdict
from haversine import haversine
from sklearn.cluster import AgglomerativeClustering

DATA_PATH = 'saved_data'


def load_data():
    hits = []
    for line in open(DATA_PATH):
        if not line:
            continue
        try:
            hits.append(json.loads(line.strip()))
        except ValueError:
            continue
    d = {}
    for h in hits:
        d.update(h)
    return d


def get_follow_edges(data):
    """FB Page A likes Page B. All those edges"""
    results = []
    for id in data:
        for like_hit in  data[id].get('likes', {}).get('data', []):
            results.append((id,like_hit.get('id')))
    return results


def get_most_common_edges(edges, n):
    return Counter(map(lambda x: x[1], edges)).most_common(n)


def get_geo_coords(data):
    results = []
    for id in data:
        loc_dict = data[id].get('', {}).get('location', {})
        if loc_dict.get('latitude') and loc_dict.get('longitude'):
            results.append((id, loc_dict['latitude'], loc_dict['longitude']))
    return results


def create_sklearn_distance_matrix(data):
    hits = []
    for id_a, lat_a, long_a in data:
        row = []
        for id_b, lat_b, long_b in data:
            dist = haversine((lat_a, long_a), (lat_b, long_b))
            row.append(dist)
        hits.append(row)
    return hits


def cluster_geo_data(geo_data, n_clusters, data):
    X = create_sklearn_distance_matrix(geos)
    model = AgglomerativeClustering(n_clusters=n_clusters)
    model.fit(X)
    cols = map(lambda x: x[0], geo_data)
    cluster_list = zip(cols, model.labels_)
    # now to get city too
    hits = []
    for page_id, cluster_id in cluster_list:
        loc_dict = data[page_id].get('', {}).get('location', {})
        hits.append((cluster_id, (page_id, loc_dict.get('city'), loc_dict.get('country'), data[page_id].get('', {}).get('name'))))
    key_func = lambda x: x[0]
    hits.sort(key=key_func)
    d = {k: list(v) for k,v in itertools.groupby(hits, key=key_func)}
    return d


def generate_clusters(geo_data, data, step=5):
    results = {}
    first_round = cluster_geo_data(geo_data, step, data)
    for c_id in first_round:
        curr_page_ids = set([t[1][0] for t in first_round[c_id]])
        curr_geo_data = filter(lambda x: x[0] in curr_page_ids, geo_data)
        sub_result = cluster_geo_data(curr_geo_data, step, data)
        results.update({str(c_id)+'_'+str(k):v for k,v in sub_result.items()})

    # for i in range(2):
    #     if previous:
    #         for cluster in results[previous]:
    #             curr_page_ids = set([t[1][0] for t in results[previous][cluster].values()])
    #             curr_geo_data = filter(lambda x: x[0] in curr_page_ids, geo_data)
    #     else:
    #         curr_geo_data = geo_data
    #         results[str(i)] = cluster_geo_data(geo_data, 5, data)
    #     previous = i
    #     level += 1
    return results


def recursive_defaultdict():
    return defaultdict(recursive_defaultdict)


def generate_dendrogram_dict(data):
    grouped_data = recursive_defaultdict()
    for cluster_id in data:
        parent, sub = cluster_id.split('_')
        grouped_data[parent][sub] = data[cluster_id]
    result = {
        'name': "World Wide",
        'children': []
    }
    parents = []
    for parent in grouped_data:
        leaves = []
        for sub in grouped_data[parent]:
            leaf = {
                'name': sub,
                'data': grouped_data[parent][sub]
            }
            leaves.append(leaf)
        parents.append({
            'name': parent,
            'children': leaves
        })
    result['children'] = parents
    return result


data = load_data()
# with open('data/our_fan_count_bubbles.csv', 'w') as f:
#     writer = csv.writer(f)
#     headers = ['name', 'id', 'fan_count', 'website', 'city', 'country']
#     writer.writerow(headers)
#     for page_id in data:
#         info_d = data[page_id].get('')
#         if not info_d:
#             continue
#         name = info_d.get("name")
#         fan_count = info_d.get('fan_count')
#         _id = info_d.get('id')
#         site = info_d.get('site')
#         city = info_d.get('location', {}).get('city')
#         country = info_d.get('location', {}).get('country')
#         writer.writerow(map(lambda x: x.encode('utf-8') if isinstance(x, basestring) else (x and str(x)), [name, _id, fan_count, site, city, country]))
# with open('js/data_as_object.js', 'w') as f:
#     f.write(json.dumps(data))
network_edges = get_follow_edges(data)
#open('influencers.txt', 'w').write(str(map(lambda x: (x[0].encode('utf-8'), x[1]), get_most_common_edges(network_edges, 50))))
geos = get_geo_coords(data)
# with open('clusters_step_5.json', 'w') as f:
#     f.write(json.dumps(generate_clusters(geos, data)))

# cluster_data = json.loads(open('clusters_step_5.json').read())
# dendro_dict = generate_dendrogram_dict(cluster_data)
# with open('dendro.json', 'w') as f:
#     f.write(json.dumps(dendro_dict))

